# Docker environment to build the kobuki-driver
This repository provides a docker environment to build ROS 2 Humble debian packages for arm64 to run Ubuntu 22.04 on the raspberry pi of the turtlebot 2.

These are unofficial packages, ros 2 humble is not supported by Yujinrobot.

## Prerequisites
Docker needs to be installed, only tested with docker-ce

## Building the image
Checkout and update this repo including all submodules: `git submodule update --init --recursive`

Run the `./build.bash` script to install everything inside the docker package and build the packages, afterwards you'll find the debian packages in the deb-<arch>-folders where <arch> is either arm64 or amd64.

## Installing packages
Simply run `dpkg -i *.deb` on your machine, however as you might not have all dependencies installed you might see some error messages starting with `dpkg: dependency problems prevent configuration of ...`. To fix that we can just run `sudo apt install -f` afterwards which should install all needed ROS 2 packages.