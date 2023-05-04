# Basics
FROM node:19.2-alpine
WORKDIR /app

# Set the timezone
ENV TZ America/Sao_Paulo
ENV CERT_SUBJ "/CN=COMMON_NAME"

# Update the container
RUN apk --update upgrade
RUN apk add --no-cache tzdata openssl
RUN npm i -g typescript

# User
RUN chown node /app
USER node

# Create the server's CSR and key
RUN mkdir certs
RUN openssl genrsa -out certs/server.key 4096
RUN openssl req -new -newkey rsa:4096 -nodes -keyout certs/server.key \
    -out certs/server.csr -subj ${CERT_SUBJ}

# Get the CA's Cert and key
COPY --chown=node certs/ca.crt ./certs/
COPY --chown=node certs/ca.key ./certs/

# Sign the server's csr with the ca
RUN openssl x509 -req -in certs/server.csr -CA certs/ca.crt -CAkey certs/ca.key \ 
    -CAcreateserial -out certs/server.crt -days 365

RUN rm certs/ca.key

# Install the project's dependencies
COPY --chown=node package.json .
RUN yarn --production


# Get the project
COPY --chown=node tsconfig.json .
COPY --chown=node src ./src

# Run the project
RUN yarn run build
CMD yarn run start