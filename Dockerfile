# Set up base root file system.
FROM scratch
ADD rootfs.tar.xz /

# BUILDENV provides the version number for the build environment.
# The format is the timestamp of the base image in YYYYMMDD format a literal '.'
# followed by a increasing counter. This counter does not reset when the base
# image is bumped. Update this counter on every change.
ENV BUILDENV 20190801.15

# Add Go support.
ADD go1.14.4.linux-amd64.tar.gz /usr/local
ENV GOPATH /src/golang/
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV GOCACHE /tmp
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# Required for GRTE based python tools.
RUN set -e; \
for v in v4 v5; do \
  mkdir -p "/usr/grte/${v}/bin"; \
  ln -s /usr/bin/python "/usr/grte/${v}/bin/python2.7"; \
done

CMD ["bash"]
