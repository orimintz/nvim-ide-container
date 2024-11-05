#!/bin/bash

# Set default value for WHITE_LIST_DOCKER if not already defined
: "${WHITE_LIST_DOCKER:=orimintz-ide}"

# Export the variable to ensure it's available to the environment
export WHITE_LIST_DOCKER

# Your script's main commands go here
echo "WHITE_LIST_DOCKER is set to $WHITE_LIST_DOCKER"

docker exec -it orimintz-ide bash
