#!/usr/bin/env bash
find -L "$dirname $(command -v ansible-silo)" -samefile "$(command -v ansible-silo)" -exec rm -f {} +
docker rmi --force $(docker images -q grpn/ansible-silo | uniq)
