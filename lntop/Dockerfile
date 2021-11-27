FROM debian:buster-slim AS builder

ARG arch

WORKDIR /build

RUN apt-get update && apt-get install -y git wget

# Debian Buster comes with Go 1.11, but we need at least 1.15, so we need to download it
RUN wget https://dl.google.com/go/go1.17.3.linux-${arch}.tar.gz && tar xzfv go1.17.3.linux-${arch}.tar.gz

RUN git clone https://github.com/edouardparis/lntop.git

ENV GOARCH=${arch}
ENV GOOS=linux
RUN cd lntop && mkdir bin/ && /build/go/bin/go build -o bin/lntop cmd/lntop/main.go

FROM tsl0922/ttyd:latest

RUN apt-get update && apt-get install -y screen vim

COPY --from=builder /build/lntop/bin/lntop /bin/

RUN groupadd -r nodecmd --gid=1000 && useradd -r -g nodecmd --uid=1000 --create-home --shell /bin/bash nodecmd

USER nodecmd
WORKDIR /home/nodecmd
