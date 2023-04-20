#!/bin/bash

sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes  ppa:deadsnakes/ppa
sudo apt update -y
sudo apt install python2 -y
sudo apt install default-jdk -y
sudo wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'