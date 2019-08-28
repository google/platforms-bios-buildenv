# Set up base root file system.
FROM scratch
ADD rootfs.tar.xz /

# Add Go support.
ADD go1.12.9.linux-amd64.tar.gz /usr/local
ENV GOPATH /src/golang/
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
ENV GOCACHE /tmp
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

CMD ["bash"]
