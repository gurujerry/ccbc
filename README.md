# docker-saltstack
Docker Compose setup to create a salt master and several minions.

# Pre-Requisites
You will need Docker and Docker Compose installed to use this project.  See Linux instructions for installing [Docker](https://docs.docker.com/engine/install/#server) and [Docker Compose](https://docs.docker.com/compose/install/linux/). If using Mac or Windows, use [Docker Desktop](https://www.docker.com/products/docker-desktop/).

Additionally, to download this repo, you will either need to:
- Install [git](https://github.com/git-guides/install-git) and `git clone` this repo
Or
- Download this repo as a zip file and extract it

# Setup
See setup instructions in comments below
```bash
# Create a directory on your machine to clone this repo to
mkdir -p /local/demo/
cd /local/demo/
# Either Use git to clone this repo OR download and unzip this repo to your local directory
## Git Clone method
git clone https://github.com/gurujerry/ccbc.git
cd /local/demo/ccbc
## Download and extract
wget https://github.com/gurujerry/ccbc/archive/refs/heads/master.zip
unzip master.zip
cd /local/demo/ccbc-master/
# Start the salt master and minion containers (this may take several minutes to provision)
docker-compose up -d
```

Once the containers have started, you can log into the command line of the salt-master server by running
```bash
docker-compose exec salt-master bash
```

From within the salt-master, you can run salt commands like
```bash
# Run a salt 'ping' test on all minions
salt '*' test.ping
# Run a command on all web servers, list 'ls -alh /tmp/'
salt 'web*' cmd.run 'ls -alh /tmp/'
# Use the salt 'pkg' module to list all software packages installed on the (2) database servers
salt 'db*' pkg.list_pkgs
# List all the grains on 'db-01'
salt 'db-01' grains.items
# Find a specific grain on all minions
salt '*' grains.item os_family
# Find one or more grains on minion 'db-01'
salt 'db-01' grains.item osfullname osrelease
# Now let's look at state
# Show (but do not apply) what the nginx state would perform if
#   installed on 'web-01'
salt 'web-01' state.show_sls nginx
# Show what the high state would perform on 'web-02'
salt 'web-02' state.show_highstate
# Apply the nginx state to 'web-02'
salt 'web-02' state.apply nginx
# Now we should be able to curl 'web-02' and see the contents of index.html
curl http://web-02
# Feel free to run more salt master commands on minions 
#   and when finished, exit the salt master container with the
#   exit command
exit
```

To stop the running containers:
```bash
# Make sure you are in the directory the 
cd /local/demo/docker-saltstack
# Run the command below to stop the running containers
docker-compose stop
# If you wish to permanently delete the containers and there base image, run the command
docker-compose down --rmi -v
```

# Debugging
> salt-master is set to accept all minions that try to connect.  Salt master and minions are on the docker-compose network, so no minions outside the docker network will be able to connect
