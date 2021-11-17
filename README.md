# open-tunnel
This is a single bash script that can be used in two complimentary ways:

* When called as 'open-tunnel' it creates an SSH session on a remote bastion node and opens a tunnel to the bastion's private network resources.
* When called as 'open-terminal' it creates an SSH session through the remote bastion's tunnel to private network resources

This allows one script to construct either type of SSH connection and establish it.  It's a lot less work than having to maintain two scripts doing nearly the same thing.

## How to Use

First, connect to the bastion and create a tunnel:

```
$ open-tunnel aws-east ec2-11-222-33-44.us-east-2.compute.amazonaws.com
```

Second, connect through the tunnel to an instance on the private side of the bastion:

```
$ open-terminal ip-10-99-10-99.us-east-2.compute.internal
```

If you have a bastion that is always up with a static IP, you don't need open-tunnel: You could just configure the bastion with options in your $HOME/.ssh/config file.  But since my bastion's are in AWS, are they stopped and started regularly, their public DNS name changes each time. So 'open-tunnel <hostname>' lets me connect to it without updating my SSH config file.. AGAIN.

## Deployment

A simple install.sh script is provided to copy the script to /usr/local/bin/open-tunnel.  It also creates a symlink as /usr/local/bin/open-terminal that points to /usr/local/open-tunnel.  One script, called two different ways.

## Operation

I'm experimenting with a new config file pattern here:

1. The script first reads $HOME/.open-tunnel-default.conf to load basic program defaults.  If you only have one set of configuration values for your bastion(s) configure them here and skip the need to specify them manually ever again.
2. If you pass individual command line parameters, these will override existing variable values.
3. If you pass a config file ID, this will load $HOME/.open-tunnel-<id>.conf and override any variables with values from the config file.

The order in which variables' values are overriden is determined by the order they are specified on the command line.

$ open-tunnel --config myregion --login minot

This will load all values from the $HOME/.open-tunnel-myregion.conf config file THEN override the login user as 'minot'.

## Config files

The config files are just bash code that is imported and executed.  Theoretically you can execute any bash code, but normally you're just setting variables here.

A typical config file simply sets one or more values like this:

```
# Username on remote SSH server
MY_USER="ec2-user"

# Port of remote SSH server
MY_REMOTE_PORT=22
```

See the sample config file for names of variables and documentation on their use.

A default config file, $HOME/.open-tunnel-default.conf is always loaded if it is present and readable.

Users may also use the '--config' parameter to import a custom config file by providing an identifier.

## Command line options

### Syntax

```
open-tunnel [options] <hostname>
open-terminal [options] <hostname>

open-tunnel [--config <config_file_id>] [--port <port>] [--login <user>] [--tunnel <tunnel_port_number>] [--debug] [--identity <identity_file_name>] <remote_hostname>
```

#### -c | --config <config_file_identifier>

Override variables by loading them in from a custom config file.  

Specify an identifier here, not a full filename.  The id is used to select a file in the format of $HOME/.open-tunnel-<identifier>.conf

Example: '-c ohio' loads $HOME/.open-tunnel-ohio.conf

#### -p | --port <port_number>

Connect to the remote host's SSH server at this port number.

#### -l | --login <username>

Connect to the remote host with this user name.

#### -t | --tunnel <tunnel_port_number>

With open-tunnel: create a tunnel on the local workstation on this port and listen for incoming traffic.
With open-terminal: Tunnel connections through this port on the local workstation's localhost interface which tunnels it through the remote bastion to private networks.

#### -i | --identity <identity_filename>

Authenticate with the remote SSH server using this SSH key in the $HOME/.ssh directory.  This is the full filename.

#### -d | --debug

Enable debugging mode to report on variables and show the actual SSH command that is executed.

#### --list

List available config files in $HOME/.open-tunnel*.conf

### Examples

Quickly and easily open a connection on an AWS cloud EC2 instance acting as a bastion.  This establishes and SSH session and creates a tunnel other clients can use to go through the bastion to cloud based private network resources.

Because the default config file has been configured with all the required options, I only have to specify the remote bastion name on the command line.

```
$ open-tunnel aws-east ec2-11-222-33-44.us-east-2.compute.amazonaws.com
```

Now I'm working in AWS ireland region and the SSH server there is on port 5022 instead of 22.  A custom config file called $HOME/.open-tunnel-ireland.conf has the name of an SSH key for my ireland instances and the MY_REMOTE_PORT variable is set to 5022.  

So instead of putting that all on the command line, just override those values via the ireland config file:

```
$ open-tunnel --config ireland aws-east ec2-11-222-33-44.us-west-1.compute.amazonaws.com
```

This time lets experiment in my home lab and set all sorts of parameters manually on the command line:

```
$ open-tunnel --login myuser --port 8022 --tunnel 9000 my-bastion-node.maxlab
```

With the first bastion example above connected, lets tunnel through it to connect to a database instance in an AWS cloud private subnet:
```
$ open-terminal ip-10-100-10-100.us-east-2.compute.internal
```

Lets do the same, but for a node in ireland?  All the special parameters for that region's nodes are in a config file, so just load it and go.

```
$ open-terminal --config ireland ip-10-100-10-100.us-east-2.compute.internal
```
