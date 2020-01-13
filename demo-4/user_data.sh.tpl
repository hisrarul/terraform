#!/usr/bin/bash
sudo apt-get install ${packages} -y
echo nameserver "${nameserver}" | sudo tee -a /etc/resolv.conf