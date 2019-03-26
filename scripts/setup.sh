#!/usr/bin/env bash

# -it flag attaches us to an interactive mode
docker run -it busybox sh

# delete all stopped containers
docker container prune

# close container
exit