title: Handy openssl commands
date: 2015-12-09 20:29:51
categories:
- security
- openssl
- encryption
tags:
- encryption
- openssl
- security
---

My Handy `openssl` command list;

##### Generate a password hash

```
openssl passwd -1
openssl passwd -1 -salt <salt> <passwd>
```

Really handy, if you vitally need to store users passwords in you system

##### Generate Randomness

```
openssl rand -base64 128
```

A nice comparison of this wold be with

```
cat /dev/urandom | head -c 128 | base64
```

Although it seems `openssl` actually uses `/dev/urandom` under the hood, when hardware is specified

##### Generating Keys

RSA Key

```
openssl genrsa -aes256 -out node.key 2048
```

Public Key

```
openssl rsa -in node.key -pubout -out node.pub.key
```

DSA key

```
openssl dsaparam -genkey 2048 -out node.dsa.key
openssl dsa -in node.dsa.key -out node.key -aes256
```

or simpler;

```
openssl dsaparam -genkey 2048 | openssl dsa -out node.key -aes256
```

ECDSA key

```
openssl ecparam -genkey -name secp256r1 -out node.ecdsa.key
openssl ec -in node.ecdsa.key -out node.key -aes256
```

or simpler;

```
openssl ecparam -genkey -name secp256r1 | openssl ec -out node.key -aes256
```

##### Self signed Keys

In order to request a new self signed certificate, and a new private key:

```
openssl req -new -x509 -keyout privkey.pem  -newkey rsa:2048
```

- `req` : certificate request and certificate generating utility
- `new` : generates a new certificate request
- `x509` : creates a test certificate or a self signed root CA
- `keyout` : the filename to write the newly created private key
- `newkey` : creates a new certificate request and a new private key

Also

Examine and verify certificate request

```
 openssl req -in node.key -text -verify -noout
```

Creating a csr with a key

```
openssl req -new -key node.key -out node.csr
```

Requesting a custom siggning certificate

```
openssl x509 -req -days 365 -in node.csr -signkey node.key -out node.crt
```

or without a csr

```
openssl req -new -x509 -days 365 -key node.key -out node.crt
```

Then creating a csr from an existing certificate

```
openssl x509 -x509toreq -in node.crt -ou node.csr -signkey node.key
```

###### x509

Display the contents of a certificate:

```
openssl x509 -in cert.pem -noout -text
```

Display the certificate serial number:

```
openssl x509 -in cert.pem -noout -serial
```

Display the certificate subject name:

```
openssl x509 -in cert.pem -noout -subject
```

Display the certificate subject name in RFC2253 form:

```
openssl x509 -in cert.pem -noout -subject -nameopt RFC2253
```

Display the certificate subject name in oneline form on a terminal supporting UTF8:

```
openssl x509 -in cert.pem -noout -subject -nameopt oneline,-esc_msb
```

Display the certificate MD5 fingerprint:

```
openssl x509 -in cert.pem -noout -fingerprint
```

Display the certificate SHA1 fingerprint:

```
openssl x509 -sha1 -in cert.pem -noout -fingerprint
```

Convert a certificate from PEM to DER format:

```
openssl x509 -in cert.pem -inform PEM -out cert.der -outform DER
```

Convert a certificate to a certificate request:

```
openssl x509 -x509toreq -in cert.pem -out req.pem -signkey key.pem
```

Convert a certificate request into a self signed certificate using extensions for a CA:

```
openssl x509 -req -in careq.pem -extfile openssl.cnf -extensions v3_ca \
        -signkey key.pem -out cacert.pem
```

Sign a certificate request using the CA certificate above and add user certificate extensions:

```
openssl x509 -req -in req.pem -extfile openssl.cnf -extensions v3_usr -CA cacert.pem -CAkey key.pem -CAcreateserial
```

Set a certificate to be trusted for SSL client use and change set its alias to "Steve's Class 1 CA"

```
openssl x509 -in cert.pem -addtrust clientAuth  -setalias "Steve's Class 1 CA" -out trust.pem
```




