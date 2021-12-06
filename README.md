# wesh

`wesh` is a web shell for the [Umbrel](https://github.com/getumbrel/) personal server.

Technically it's just a Docker container with [ttyd](https://github.com/tsl0922/ttyd) and some additional utilities.

# Why?

The web-based tools that come with Umbrel are amazing but there will always be some case where you want to access the terminal, whether to investigate system performance using standard Linux tools or to run some of the many amazing command-line utilities useful for managing your LN node.

## Why not just SSH?

SSH works very well indeed. The problem is the compilation, packaging and configuration of the utilities.

Let's say you compile `lntop` and make it work on your Umbrel - it's not hard, but it may be a bit of a challenge for a complete beginner. Then you want to update Umbrel OS - *bang* you just lost `lntop`. Good luck bringing it back if you didn't write down the exact steps.

And every such utility has its own quirks about how it needs to be installed and configured. You spend time figuring it all out, then you lose it all with a simple OS update.

An alternative is, of course, to keep scripts of the exact steps so you can re-run them when needed. And this is exactly what I did with `wesh`.

**Feel free to simply copy-paste parts of the Dockerfile. There is no need to install the whole thing.**

# Building

The docker image can be built using `docker buildx build --platform=linux/arm64 --build-arg arch=arm64 .`

# Pre-built images

You can run a pre-built image from Docker Hub directly on your Umbrel using `docker run -p 7681:7681 ibz0/wesh:v0.2.1`. You can then access the shell by pointing your browser at http://umbrel.local:7681.

# Included utilities

* `lncli`
* [`charge-lnd`](https://github.com/accumulator/charge-lnd)
* [`lntop`](https://github.com/edouardparis/lntop)
* [`rebalance-lnd`](https://github.com/C-Otto/rebalance-lnd)
* [`suez`](https://github.com/prusnak/suez)

# Configuration

Running any of the above-mentioned utilities should just work (without you having to tell them how to connect to LND!) provided you pass the following environment variables to the Docker container: `LND_HOST`, `LND_ADDRESS`, `CERT_PATH`, `MACAROON_PATH` and mount the `lnd` directory under `/lnd`. This is normally done by Umbrel itself if you start wesh using Umbrel's dashboard or `scripts/app start` (which starts the container using docker-compose and does all the magic).

## How does this work?

There are some additional scripts in `~/.local/bin` named the same as the above, which take care of passing the necessary arguments.
