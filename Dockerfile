ARG ttyd_tag=1.6.3

ARG charge_lnd_tag=v0.2.8
ARG lnd_tag=v0.14.1-beta
ARG lntop_commit=a05908a
ARG rebalance_lnd_tag=v2.1
ARG suez_commit=335d430

FROM debian:buster-slim AS builder

ARG arch

ARG ttyd_tag
ARG lnd_tag
ARG lntop_commit
ARG suez_commit

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

# getting lnd
RUN curl -sSL -o /lnd.tgz https://github.com/lightningnetwork/lnd/releases/download/${lnd_tag}/lnd-linux-${arch}-${lnd_tag}.tar.gz
RUN cd / && tar xzf lnd.tgz && mv lnd-linux-${arch}-${lnd_tag} /lnd

FROM debian:buster-slim

ARG charge_lnd_tag
ARG rebalance_lnd_tag
ARG suez_commit

RUN apt-get update && apt-get install -y curl git libjson-c-dev libwebsockets-dev procps python3 python3-grpcio python3-pip screen sysstat tini vim

COPY --from=builder /build/ttyd /bin/

COPY --from=builder /build/lntop/bin/lntop /bin/

RUN git clone --depth 1 --branch ${charge_lnd_tag} https://github.com/accumulator/charge-lnd.git /charge-lnd
# we already installed grpcio above using apt-get. installing it via pip would take forever on arm64 (no compatible wheel exists, so it would try to compile it from source)
RUN cd /charge-lnd && cat requirements.txt | grep -v grpcio > requirements-nogrpcio.txt && pip3 install -r requirements-nogrpcio.txt
RUN cd /charge-lnd && python3 setup.py install
RUN rm -rf /charge-lnd

RUN git clone --depth 1 --branch ${rebalance_lnd_tag} https://github.com/C-Otto/rebalance-lnd.git /rebalance-lnd
# no grpcio again, same as above
RUN cd /rebalance-lnd && cat requirements.txt | grep -v grpcio > requirements-nogrpcio.txt && pip3 install -r requirements-nogrpcio.txt

RUN git clone https://github.com/prusnak/suez.git /suez && cd /suez && git checkout ${suez_commit}
COPY --from=builder /build/suez/requirements.txt /suez/requirements.txt
RUN pip3 install -r /suez/requirements.txt

COPY --from=builder /lnd/lncli /bin

RUN groupadd -r wesh --gid=1000 && useradd -r -g wesh --uid=1000 --create-home --shell /bin/bash wesh

USER wesh
WORKDIR /home/wesh

RUN mkdir -p /home/wesh/.local/bin
COPY --chown=wesh:wesh bin/charge-lnd bin/rebalance-lnd bin/suez bin/lncli /home/wesh/.local/bin/
RUN cd /home/wesh/.local/bin/ && chmod o+x charge-lnd rebalance-lnd suez lncli
RUN echo "PATH=~/.local/bin:$PATH; export PATH" >> /home/wesh/.bashrc

EXPOSE 7681

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/bin/ttyd", "bash"]
