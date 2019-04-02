#!/usr/bin/env bash
export ANSIBLE_ROOT=$(pwd)  # So source this from the ansible root directory
export ANSIBLE_VAULT_PASSWORD_FILE=$ANSIBLE_ROOT/.ansible-vault-pass
export ANSIBLE_CONFIG=$ANSIBLE_ROOT/.ansible.cfg
export ANSIBLE_ROLES_PATH=$ANSIBLE_ROOT/roles
export ANSIBLE_COW_SELECTION=random
export ANSIBLE_HOST_KEY_CHECKING=0
export PYTHONHTTPSVERIFY=0
export VAGRANT_IGNORE_WINRM_PLUGIN=1
export MOLECULE_DEBUG=1
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

