#!/usr/bin/env bash
docker run --interactive --tty --rm --volume "/usr/local/bin:/silo_install_path" grpn/ansible-silo:2.1.0 --install
