# #!/bin/bash

# Install required dependencies for Functional Tests
apt update
apt install -y make wget
pip install -r rstuf-umbrella/requirements.txt
pip install repository-service-tuf

# Execute the Ceremony using DAS
python rstuf-umbrella/tests/rstuf-admin-ceremony.py '{
    "Do you want more information about roles and responsibilities?": "n",
    "Do you want to start the ceremony?": "y",
    "What is the metadata expiration for the root role?(Days)": "365",
    "What is the number of keys for the root role?": "3",
    "What is the key threshold for root role signing?": "2",
    "What is the metadata expiration for the targets role?": "365",
    "Show example?": "n",
    "Choose the number of delegated hash bin roles": "4",
    "What is the targets base URL": "http://rstuf.org/downloads",
    "What is the metadata expiration for the snapshot role?(Days)": "1",
    "What is the metadata expiration for the timestamp role?(Days)": "1",
    "What is the metadata expiration for the bins role?(Days)": "1",
    "(online) Select the ONLINE`s key type [ed25519/ecdsa/rsa] (ed25519)": "",
    "(online) Enter ONLINE`s key id": "f7a6872f297634219a80141caa2ec9ae8802098b07b67963272603e36cc19fd8",
    "(online) Enter ONLINE`s public key hash": "9fe7ddccb75b977a041424a1fdc142e01be4abab918dc4c611fbfe4a3360a9a8",
    "Give a name/tag to the key [Optional]": "online v1",
    "Ready to start loading the root keys?": "y",
    "(root 1) Select the root`s key type [ed25519/ecdsa/rsa] (ed25519)": "ed25519",
    "(root 1) Enter the root`s private key path": "tests/files/key_storage/JanisJoplin.key",
    "(root 1) Enter the root`s private key password": "strongPass",
    "(root 1) [Optional] Give a name/tag to the key": "JJ",
    "(root 2) Select to use private key or public info? [private/public] (public)": "public",
    "(root 2) Select the root`s key type [ed25519/ecdsa/rsa] (ed25519)": "",
    "(root 2) Enter root`s key id": "800dfb5a1982b82b7893e58035e19f414f553fc08cbb1130cfbae302a7b7fee5",
    "(root 2) Enter ONLINE`s public key hash": "7098f769f6ab8502b50f3b58686b8a042d5d3bb75d8b3a48a2fcbc15a0223501",
    "(root 2) [Optional] Give a name/tag to the key": "JH",
    "(root 3) Select to use private key or public info? [private/public] (public)": "public",
    "(root 3) Select the root`s key type [ed25519/ecdsa/rsa] (ed25519)": "",
    "(root 3) Enter root`s key id": "7641c1c12b98c18cfbadd87209fe190072e712cc0e14e13fe83febc2150f7520",
    "(root 3) Enter ONLINE`s public key hash": "414af03cbaae93b5f44363f0bf757421e64bd892b891b0dff3ad6af5eb3a3038",
    "(root 3) [Optional] Give a name/tag to the key": "JC",
    "Is the online key configuration correct? [y/n]": "y",
    "Is the root configuration correct? [y/n]": "y",
    "Is the targets configuration correct? [y/n]": "y",
    "Is the snapshot configuration correct? [y/n]": "y",
    "Is the timestamp configuration correct? [y/n]": "y",
    "Is the bins configuration correct? [y/n]": "y"
}'

# Bootstrap using DAS
rstuf admin ceremony -b -u -f payload.json --upload-server http://repository-service-tuf-api


# Finish the DAS signing the Root Metadata (bootstrap)
python rstuf-umbrella/tests/rstuf-admin-metadata-sign.py '{
    "API URL address:": "http://repository-service-tuf-api",
    "Choose a metadata to sign [root]": "root",
    "Choose a private key to load [JC]": "JC",
    "Select the root`s key type [ed25519/ecdsa/rsa] (ed25519)": "",
    "Enter the root`s private key path": "tests/files/key_storage/JoeCocker.key",
    "Enter the root`s private key password": "strongPass"
}'

# Get initial trusted Root
rm metadata/1.root.json
wget -P metadata/ http://web:8080/1.root.json
cp -r metadata rstuf-umbrella/

# Functional Tests (BDD)
make -C rstuf-umbrella/ functional-tests-exitfirst
