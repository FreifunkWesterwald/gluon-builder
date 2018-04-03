# Docker Container for Gluon building
The purpose of this container to make it possible to build Gluon on Debian Jessie inside another development environment. Docker works in two steps:

1. In the build step a container is created.
2. In the run step, an already created container is instantiated.

## Container Building  
Create the image.
```sh
docker build -t gluon-builder .
```

### Notes
* option "-t gluon-builder": name of the image

## Container useage
Log in into the container.
```sh
docker run --rm -it gluon-builder
```
