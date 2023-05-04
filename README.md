# BillsFix
The BillsFix is a web-script application, that uses the system of ContaAzul to update the bills to receive.
It will check and fix the data from some orders that are with the incorrect date to some customers.


For example, the customer X has a 30 days to pay the service, but for some reason, the bills are not updated.
In this case, this program will do the job to fix it to you.

## Pre-requisites
- Docker

## Usage
First at all, you need a CA cert and key. If you already has the certificates from some company,
you'll need to comment or remove the lines from the `Dockerfile` related to the auto sign from the server.


To generate the CA Cert and private key:
```sh
SUBJ="/CN=COMMON_NAME"

# Generate CA private key
openssl genrsa -out certs/ca.key 4096

# Generate CA certificate
openssl req -new -x509 -subj ${SUBJ} -days 365 -key certs/ca.key -out certs/ca.crt
```