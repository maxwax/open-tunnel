#!/bin/bash

echo "Deploy open-tunnel to /usr/local/bin"
sudo cp -pr open-tunnel /usr/local/bin
sudo chmod a+rx /usr/local/bin/open-tunnel
