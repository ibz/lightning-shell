# wesh

`wesh` is a web shell for the [Umbrel](https://github.com/getumbrel/) personal server.

Technically it's basically [ttyd](https://github.com/tsl0922/ttyd) packaged for Umbrel plus some additional utilities.

# Why?

The web-based tools that come with Umbrel are amazing but there will always be some case where you want to access the terminal, whether to investigate system performance using standard Linux tools or to run some of the many amazing command-line utilities useful for managing your LN node.

# Why not just SSH?

SSH works very well indeed. The problem is the compilation / packaging of the utilities.

Let's say you compile `lntop` and make it work on your Umbrel - it's not hard, but also non-trivial for beginners. Then you want up update Umbrel OS - *bang* you just lost `lntop`.

# Build

The docker image can be built using `docker buildx build --platform=linux/arm64 --build-arg arch=arm64 .`

# Pre-built images

You can run a pre-built image from Docker Hub using `docker run -p 7681:7681 ibz0/wesh:v0.0.7`. You can then access the shell by pointing your browser to http://localhost:7681

# Included utilities

For now, [`lntop`](https://github.com/edouardparis/lntop/), which I found very useful in observing issues with Lightning channels. Plus the standard stuff you know from Linux. More to come.

# Example commands

* `top`
* `iostat -dx 1`
* `lntop`
