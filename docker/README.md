# Docker Container for Gluon building
The purpose of this container to make it possible to build Gluon on Debian Jessie inside another development environment. Docker works in two steps:

1. In the build step a container is created.
2. In the run step, an already created container is instantiated.

## Container Building  
Create the image.
```sh
cd image
docker build -t gluon-builder .
```

### Notes
* option "-t gluon-builder": name of the image

## Container useage
Log in into the container.
```sh
docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix/:/tmp/.X11-unix -it gluon-builder
```

### Notes
* option "-e DISPLAY=$DISPLAY": Set DISPLAY environment variable to current display on the host machine
* option "-v /tmp/.X11-unix/:/tmp/.X11-unix": Mount the X11 socket directory from the host machine in the container