# Set up base root file system.
FROM scratch
ADD rootfs.tar.xz /

# BUILDENV provides the version number for the build environment.
# The format is the timestamp of the base image in YYYYMMDD format a literal '.'
# followed by a increasing counter. This counter does not reset when the base
# image is bumped. Update this counter on every change.
ENV BUILDENV 20190801.3

# Add Go support.
ADD go1.12.9.linux-amd64.tar.gz /usr/local
ENV GOPATH /src/golang/
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV GOCACHE /tmp
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Required for GRTE based python tools.
RUN mkdir -p /usr/grte/v4/bin
RUN ln -s /usr/bin/python /usr/grte/v4/bin/python2.7

CMD ["bash"]
