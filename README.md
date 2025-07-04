# Docker environment to cross-compile the kobuki-driver
This repository provides a docker environment to build ROS 2 jazzy debian packages for arm64 to run Ubuntu 22.04 on the raspberry pi of the turtlebot 2.

Note that these are unofficial packages, ros 2 jazzy is not supported by Yujinrobot.

## Prerequisites
Docker needs to be installed, only tested with docker-ce

## Building the image
Instead of building yourself you can just download and install from the [Releases-page](https://github.com/helloric/docker-kobuki-compile/releases/)

Checkout and update this repo including all submodules: `git submodule update --init --recursive`

Run the `./build.bash` script to install everything inside the docker package and build the packages, afterwards you'll find the debian packages in the deb-<arch>-folders where <arch> is either arm64 or amd64.

## Installing packages
Simply download the .deb-files from the [Releases-page](https://github.com/helloric/docker-kobuki-compile/releases/) and run `dpkg -i *.deb` on your machine, however as you might not have all dependencies installed you might see some error messages starting with `dpkg: dependency problems prevent configuration of ...`. To fix that we can just run `sudo apt install -f` afterwards which should install all needed ROS 2 packages.

## Contributing
Note that this repo only provides a docker environment to cross-compile the debian-packages for issues with the functionality itself report issues at the [kobuki_ros issue tracker](https://github.com/kobuki-base/kobuki_ros/issues).

Please use the [issue tracker](https://github.com/helloric/docker-kobuki-compile/issues) to submit bug reports and feature requests. Please use merge requests as described [here](/CONTRIBUTING.md) to add/adapt functionality. 

## License

this docker environment setup is distributed under the [3-clause BSD license](https://opensource.org/licenses/BSD-3-Clause).

## Maintainer / Authors / Contributers

Andreas Bresser, andreas.bresser@dfki.de
