# Platforms BIOS Build Environment

This project tracks the Docker image that Google uses for building server BIOS.
We use Docker images in order to provide a well-defined enviroment and
tool-chain that allows for reproducible builds across developers,
automated-builders and vendors.

We use [debuerreotype](https://github.com/debuerreotype/debuerreotype) to create
reproducible images. For the purposes of this project, Debian packages are deemed
to be trusted. Once an engineer proposes a change to the image, the reviewer
uses the build script to generate the same image and verify that the proposed
image has not been tampered with.

This image has been used sucessfuly to build projects based on:
* (EDK2)[https://github.com/tianocore/edk2]
* (u-root)[https://github.com/u-root/u-root]

Each instance of the environment sets BUILDENV global variable. This can be used
to keep track of that version of the enviroment was used in any particular
build.

Official images are distributed on gcr.io/platforms-bios/buildenv .
