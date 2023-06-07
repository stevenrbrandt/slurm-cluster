
# Server Setup
## Building FreeIPA server image

    git clone https://github.com/freeipa/freeipa-container.git
    cd freeipa-container
    docker build -t freeipa-server -f Dockerfile.fedora-38 .

## Setup
The FreeIPA container will store all its configurations and data on
volume mounted to `/data` directory in the container. We create
directory which will hold the server data on the host.
    
    mkdir /persistant_data/ipa-data

### Interactive setup
Upon the first invocation with empty directory mounted to `/data`,
the container will run either `ipa-server-install` or `ipa-replica-install` to configure 

    docker run --name freeipa-server-container -ti \
        -h ipa.cluster.test --read-only \
        -v /var/lib/ipa-data:/data:Z freeipa-server [ opts ]

For exmaple:

    docker run -ti -h ipa.cluser.test --read-only \
        -v /var/lib/ipa-data:/data:Z \
        freeipa-server ipa-server-install -r CLUSTER.TEST --no-ntp

### Unattended setup
For unattended initial installation, use
the `-U` argument to `ipa-server-install` and specify all the necessary
inputs as argument on the command line, for example

    docker run -ti -h ipa.cluster.test --read-only \
        -v /var/lib/ipa-data:/data:Z \
        -e PASSWORD=Secret123 \
        freeipa-server ipa-server-install -U -r CLUSTER.TEST --no-ntp

It is also possible to store the options is file named `ipa-server-install-options` in the directory mounted
to the container as `/data`. For example

    --realm=Cluster.TEST
    --ds-password=The-directory-server-password
    --admin-password=The-admin-password

# Client Setup

Two packages `freeipa-client` and `oddjob-mkhomedir` should be installed on ubuntu clients

    sudo apt install  freeipa-client oddjob-mkhomedir

Then this command will install the client:

    sudo ipa-client-install \
        --mkhomedir \
        --server=ipa.cluster.test \
        --domain cluster.test \
        --realm CLUSTER.TEST \
        --unattended \
        --no-ntp \
        --principal=admin \
        --password=The-admin-password
