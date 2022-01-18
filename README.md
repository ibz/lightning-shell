# Lightning Shell

Please see [lightningshell.app](https://lightningshell.app) for more information about **Lightning Shell**.

## Running

**The recommended way to run *Lightning Shell* is from your personal server's dashboard.**

Keep reading if you want to build it yourself. This is **not** recommended for the average user. Follow these instructions only if you *really* know what you are doing!

## Building

1. Edit `Dockerfile.tmpl` as needed.
1. Run `./generate-dockerfiles.sh` to generate Dockerfiles based on **Debian Buster** and **Debian Bullseye**.
1. Build the image using something like this: `docker buildx build --platform=linux/arm64 --build-arg arch=arm64 --build-arg version=dev --file Dockerfile.bullseye .`
   * make sure you build using the desired platform (`arm64` or `amd64`) and base image (`.buster` or `.bullseye`)
   * pass something like `--tag X/Y:Z --output "type=registry"` in order to publish the image to your container registry so you can pull it on your personal server
