FROM debian:buster-slim AS builder

ARG arch

ARG ttyd_tag=1.6.3

ARG lntop_commit=a05908a
ARG suez_commit=335d430
ARG rebalance_lnd_tag=v2.1

WORKDIR /build

RUN apt-get update && apt-get install -y build-essential cmake curl git libjson-c-dev libwebsockets-dev python3 python3-venv

# building ttyd

RUN cd /build && git clone --depth 1 --branch ${ttyd_tag} https://github.com/tsl0922/ttyd.git
RUN cd /build/ttyd && mkdir build && cmake . && make

# building lntop

# Debian Buster comes with Go 1.11, but we need at least 1.15, so we need to download it
RUN cd /build && curl -sSL -o go.tgz https://dl.google.com/go/go1.17.3.linux-${arch}.tar.gz && tar xzf go.tgz
RUN cd /build && git clone https://github.com/edouardparis/lntop.git && cd lntop && git checkout ${lntop_commit}
ENV GOARCH=${arch}
ENV GOOS=linux
RUN cd /build/lntop && mkdir bin && /build/go/bin/go build -o bin/lntop cmd/lntop/main.go

# extracting suez requirements

RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python3 -
RUN cd /build && git clone https://github.com/prusnak/suez.git && cd suez && git checkout ${suez_commit} && /root/.local/bin/poetry export -f requirements.txt --output requirements.txt --without-hashes

FROM debian:buster-slim

RUN apt-get update && apt-get install -y curl git libjson-c-dev libwebsockets-dev procps python3 python3-grpcio python3-pip screen sysstat tini vim

COPY --from=builder /build/ttyd /bin/

COPY --from=builder /build/lntop/bin/lntop /bin/

RUN git clone https://github.com/prusnak/suez.git /suez && cd /suez && git checkout ${suez_commit}
COPY --from=builder /build/suez/requirements.txt /suez/requirements.txt
RUN pip3 install -r /suez/requirements.txt

RUN git clone https://github.com/C-Otto/rebalance-lnd.git /rebalance-lnd && cd /rebalance-lnd && git checkout ${rebalance_lnd_tag}
# we already installed grpcio above using apt-get. installing it via pip would take forever on arm64 (no compatible wheel exists, so it would try to compile it from source)
RUN cd /rebalance-lnd && cat requirements.txt | grep -v grpcio > requirements-nogrpcio.txt && pip3 install -r requirements-nogrpcio.txt

COPY rebalance-lnd /bin/
RUN chmod +x /bin/rebalance-lnd

RUN groupadd -r wesh --gid=1000 && useradd -r -g wesh --uid=1000 --create-home --shell /bin/bash wesh

USER wesh
WORKDIR /home/wesh

EXPOSE 7681

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/bin/ttyd", "bash"]
