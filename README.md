# Lightning Shell

**Lightning Shell** is a web shell for Bitcoin nodes.
Currently, it's used on [Umbrel](https://github.com/getumbrel/umbrel) and [Citadel](https://github.com/runcitadel/core).

Technically it's just a Docker container with [ttyd](https://github.com/tsl0922/ttyd) and some additional utilities.

# Why?

The web-based tools that come with Umbrel are amazing but there will always be some case where you want to access the terminal, whether to investigate system performance using standard Linux tools or to run some of the many amazing command-line utilities useful for managing your LN node.

## Why not just SSH?

SSH works very well indeed. The problem is the compilation, packaging and configuration of the utilities.

Let's say you compile `lntop` and make it work on your node - it's not hard, but it may be a bit of a challenge for a complete beginner. Then you want to update the OS and reflash the SD card - _bang_ you just lost `lntop`. Good luck bringing it back if you didn't write down the exact steps.

And every such utility has its own quirks about how it needs to be installed and configured. You spend time figuring it all out, then you lose it all with a simple reflash.

An alternative is, of course, to keep scripts of the exact steps so you can re-run them when needed. And this is exactly what I did.

**Feel free to simply copy-paste parts of the Dockerfile. There is no need to install the whole thing.**

# Building

The Dockerfile can be generated using `./generate-dockerfiles.sh`, then,
the container can be built using
`docker buildx build --platform=linux/arm64 --build-arg arch=arm64 --build-arg versioon=dev .`

# Included utilities

- `lncli`
- [`charge-lnd`](https://github.com/accumulator/charge-lnd)
- [`lntop`](https://github.com/edouardparis/lntop)
- [`rebalance-lnd`](https://github.com/C-Otto/rebalance-lnd)
- [`suez`](https://github.com/prusnak/suez)
- [`bos`](https://github.com/alexbosworth/balanceofsatoshis)

# Configuration

Running any of the above-mentioned utilities should just work (without you having to tell them how to connect to LND!) provided you pass the `LND_IP` environment variable to the Docker container and mount the `lnd` directory under `/lnd`. This is normally done by the host system itself if you start Lightning Shell using your node's dashboard.

## How does this work?

There are some additional scripts in `~/.local/bin` named the same as the above, which take care of passing the necessary arguments.
