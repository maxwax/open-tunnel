# CHANGLOG for 'open-tunnel/open-terminal' script

## 0.9.1 Reworked as open-tunnel/tunnel-terminal

* Renaming open-tunnel as tunnel-terminal because open-terminal sounds universal and this script is really only for establishing SSH connections *through a tunnel*

## 0.9 Reworked as open-tunnel/open-terminal

* Major modifications so this script can be used as open-tunnel or open-terminal
* When called natively as open-tunnel it creates an SSH connection to a bastion and opens a tunnel on it
* When called as open-terminal (symlinked to open-tunnel) it creates an SSH connection through the tunnel to remote private instances

* Modify install.sh to create an open-terminal symlink to open-tunnel
* execute ssh via 'eval ssh...' in order to work around Bash expansion/evaluation of quotes within strings.
* Updated documentation

## 0.2 Initial Release

* Added a simple install.sh script so I can deploy it via Chef. To simple to make an .rpm package.

## 0.1 Initial Release

* Works but may be buggy, needs me to give it some use testing.
