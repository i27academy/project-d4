#!/bin/bash
sudo apt update -y
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible -y
sudo apt install ansible -y