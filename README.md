# docker-saltstack
Docker Compose setup to create a salt master and several minions.

# Pre-Requisites
You will need Docker and Docker Compose installed to use this project.  See Linux instructions for installing [Docker](https://docs.docker.com/engine/install/#server) and [Docker Compose](https://docs.docker.com/compose/install/linux/). If using Mac or Windows, use [Docker Desktop](https://www.docker.com/products/docker-desktop/).

Additionally, to download this repo, you will either need to:
- Install [git](https://github.com/git-guides/install-git) and `git clone` this repo
Or
- Download this repo as a zip file and extract it

> Note: Older versions of docker compose will use the `docker-compose` command versus the newer `docker compose` command

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
docker compose up -d
```

Once the containers have started, you can log into the command line of the salt-master server by running
```bash
docker compose exec salt-master bash
```

From within the salt-master, you can run salt commands like
```bash
# Let's verify we are in the salt master by running 'hostname'
hostname
# Run a salt 'ping' test on all minions
salt '*' test.ping
# Run a command on all (2) web servers, list 'ls -alh /etc/'
salt 'web*' cmd.run 'ls -alh /etc/'
# Use the salt 'pkg' module to list all software packages installed on the (2) database servers
salt 'db*' pkg.list_pkgs
# List all the grains on 'db-01'
salt 'db-01' grains.items
# Find a specific grain on all minions
salt '*' grains.item os_family
salt '*' grains.item ip_interfaces
# Find one or more grains on minion 'db-01'
salt 'db-01' grains.item osfullname osrelease
# We might use a salt execution module, if a software update comes out for a package like 'openssl' and
#   we need to determine what version our servers are running:
salt '*' pkg.version openssl
# We could even pro-actively check if an update is availabe for 'openssl'
salt '*' pkg.upgrade_available openssl
# At any point, we can see the list of previously ran jobs on the salt master with the command:
salt-run jobs.list_jobs
# Previous commands used the salt execution module, Now let's look at the state module!
# We can view the salt states available on the master with the command
salt-run fileserver.file_list
# In a text editor like vscode we can see that these folders/files are the same as the contents
#   of this repos "states/" folder. This is because we mount the folder into the salt-master
# Show (but do not apply) the high state on 'dns-01'
salt 'dns-01' state.show_highstate
# Apply the high state (if it has not already run) on 'dns-01'
salt 'dns-01' state.apply
# Show (but do not apply) what the nginx state would perform if
#   installed on 'web-01'
salt 'web-01' state.show_sls nginx
# Apply the nginx state to 'web-02'
salt 'web-02' state.apply nginx
# Now we should be able to curl 'web-02' and see the contents of index.html
curl http://web-02
# Let's take a look at the 'postgres' state and apply it to our database servers
salt 'db*' state.apply postgres
# Looking at our text editor, we can see a 'win_update' state, what happens if we 
#  try to apply that to a Linux host?
salt 'db-01' state.apply win_update
# We should see an error 'The shell powershell is not available'. To prevent this, we 
#   could add JINJA logic to check that the minion is a Windows Host before executing the state
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
docker compose stop
# If you wish to permanently delete the containers and their base image, run the command
docker compose down --rmi local -v
```

# Debugging
> salt-master is set to accept all minions that try to connect.  Salt master and minions are on the docker compose network, so no minions outside the docker network will be able to connect
