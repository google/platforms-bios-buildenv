# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Set up base root file system.
FROM scratch
ADD third_party/rootfs.tar.xz /

# BUILDENV provides the version number for the build environment.
# The format is the timestamp of the base image in YYYYMMDD format a literal '.'
# followed by a increasing counter. This counter does not reset when the base
# image is bumped. Update this counter on every change.
ENV BUILDENV 20190801.19

# Add Go support.
ADD third_party/go1.15.10.linux-amd64.tar.gz /usr/local
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
