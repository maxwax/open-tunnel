# open-tunnel
This is a Bash script to easily and flexibly open an SSH tunnel through a remote bastion.

In most cases, I just name the remote SSH bastion and easily connect:

```
$ open-tunnel aws-east ec2-11-222-33-44.us-east-2.compute.amazonaws.com
```

I stop my personal lab's bastions when not in use and after re-starting them the instance's public IP addresses change.

This script lets me re-establish a tunnel connection just by copy & pasting the bastion's new public IP address.

By loading consistent SSH parameters from config files, I can avoid retyping them or having to edit command line history.

## Operation

The script will read a default configuration file, $HOME/.open-tunnel-default.conf and read in my most commonly used values for tunneling.  For example, I define the SSH key of my lab's bastion here as well as my normal local port for dynamic forwarding to the bastion.

It will then construct an SSH command and establish a connection with tunneling to the remote host specified last on the command line.

The user can opt to:

* Use only a single default config file and simply name the remote host
* Avoid using a config file at all
* Use multiple custom config files with sets of unique parameters
* Use individual command line parameters to constuct the SSH connection
* Combine any of the above to meet their needs

This allows the possibility that common defaults could be read from the default file, then the '-c' parameter replaces some or all of those values with those from a different config file and finally individual CLI parameters replace those values.  The flexibility is there if you need it, but normally, setup a default config file, use that and just name the remote host.

## Config files

The config files are snippets of bash code that is imported and executed inline with the main script.

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
open-tunnel [-c config_file_id] [-p port] [-u user] [-f forward_port] [-d] [-i identity_file] <hostname>
```

#### -c | --config <config_file_identifier>

Import and replace SSH connection parameters values using a named custom config file.

The id is used to select a file in the format of $HOME/.open-tunnel-<identifier>.conf

Example: '-c ohio' loads $HOME/.open-tunnel-ohio.conf

The config file is a Bash script doing nothing more than setting one or more variables.  See the sample file provided.

#### -p | --port <port_number>

Connect to the remote SSH server at this specified port.

#### -u | --user <username>

Connect to the remote SSH server using this login name.

#### -f | --forward <forward_port>

Open this port on the LOCAL system and forward traffic received on it to the remote bastion to access the remote network's resources.

#### -i | --identity <identity_filename>

Use this SSH key file in $HOME/.ssh to authenticate with the remote SSH server.

#### -d | --debug

Enable debugging mode to report on variables and show the actual SSH command that is executed.

### Examples

Just open a connection to my favorite bastion. The default config file has the usual details.

```
$ open-tunnel aws-east ec2-11-222-33-44.us-east-2.compute.amazonaws.com
```

Open a connection to an AWS instance as 'myuser' at SSH server port 8022 and open local port 9000 for tunneling traffic.

```
$ open-tunnel -u myuser -p 8022 -D 9000 aws-east ec2-11-222-33-44.us-east-2.compute.amazonaws.com
```

Open a connection to an AWS bastion using a config file with details for region Ireland and also replace the remote SSH port in the config file with 7022.

```
$ open-tunnel -c aws-ireland -p 7022 aws-east ec2-11-222-33-44.us-east-2.compute.amazonaws.com
```
