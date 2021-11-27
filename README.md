# wesh

`wesh` is a web shell for the [Umbrel](https://github.com/getumbrel/) personal server.

# Why?

The web-based tools that come with Umbrel are amazing but there will always be some case where you want to access the terminal, whether to investigate system performance using standard Linux tools or to run some of the many amazing command-line utilities useful for managing a LN node.

# Build

The docker image can be built using `docker buildx build --platform=linux/arm64 --build-arg arch=arm64 .`

# Pre-built images

You can run a pre-built image from Docker Hub using `docker run -p 7681:7681 ibz0/wesh:v0.0.7`. You can then access the shell by pointing your browser to http://localhost:7681

# Example commands

* `top`
* `iostat -dx 1`
* [`lntop`](https://github.com/edouardparis/lntop/)
