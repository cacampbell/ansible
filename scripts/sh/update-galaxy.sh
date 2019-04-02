#!/usr/bin/env bash
grep 'name:' requirements.yml | awk -F: '{print $2}' | xargs -I {} ansible-galaxy remove {}
ansible-galaxy install -r requirements.yml
