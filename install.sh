#!/bin/bash

echo "Deploy open-tunnel to /usr/local/bin"

# Deploy it
sudo cp -pr open-tunnel /usr/local/bin

# Make it executable
sudo chmod a+rx /usr/local/bin/open-tunnel

# Make a symlink to it as open-terminal so that command works too
if [[ ! -L /usr/local/bin/tunnel-terminal ]]
then
  sudo ln -s /usr/local/bin/open-tunnel /usr/local/bin/tunnel-terminal
fi

echo
ls -l /usr/local/bin/open-tunnel
ls -l /usr/local/bin/tunnel-terminal
