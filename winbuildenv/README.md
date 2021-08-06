This folder contains a reference Dockerfile script for creating Windows based
build environment for BIOS source code. This has been verified to build EDK2
based BIOS.

These images do not have the same security properties as our Linux images,
several components are fetched from the Internet at install time. We are not
planning to use this image for building production images but rather as a
convenient stop-gap for projects that are yet to migrate to GCC.

When using these images make sure you comply to the underlying licensing for
MSVC tools available at https://www.visualstudio.com/license-terms/mlt553512/ .
This image is and will not be available at gcr.io/platforms-bios .


## Caveats

Source code needs to be copied inside the Docker environment to avoid symlinks.
EDK2 does not seem to generate correct Makefiles in this case. We use the
following command to do this:

```
robocopy C:\x C:\src /MIR /XD .git /XD .repo /NFL /NDL /nc /ns
```
