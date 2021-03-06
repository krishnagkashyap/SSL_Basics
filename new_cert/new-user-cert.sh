#!/bin/sh
##
##  new-user-cert.sh - create the user cert for personal use.
##  Copyright (c) 2000 Yeak Nai Siew, All Rights Reserved. 
##

# Create the key. This should be done once per cert.
CERT=$1
if [ $# -ne 1 ]; then
        echo "Usage: $0 user@email.address.com"
        exit 1
fi
if [ ! -f $CERT.key ]; then
	echo "No $CERT.key round. Generating one"
	openssl genrsa -out $CERT.key 1024
	echo ""
fi

# Fill the necessary certificate data
CONFIG="user-cert.conf"
cat >$CONFIG <<EOT
[ req ]
default_bits			= 1024
default_keyfile			= user.key
distinguished_name		= req_distinguished_name
string_mask			= nombstr
req_extensions			= v3_req
[ req_distinguished_name ]
commonName			= Common Name (eg, John Doe)
commonName_max			= 64
emailAddress			= Email Address
emailAddress_max		= 40
[ v3_req ]
nsCertType			= client,email
basicConstraints		= critical,CA:false
authorityInfoAccess 		= OCSP;URI:http://slc03snd.us.oracle.com:9797
keyUsage 			= nonRepudiation, digitalSignature, keyEncipherment
#extendedKeyUsage = OCSPSigning
EOT

echo "Fill in certificate data"
openssl req -new -config $CONFIG -key $CERT.key -out $CERT.csr

rm -f $CONFIG

echo ""
echo "You may now run ./sign-user-cert.sh to get it signed"
