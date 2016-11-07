#!/bin/bash

# Go to Directory of script
cd "$( dirname "${BASH_SOURCE[0]}" )"

git pull

echo "Installing predependencies"
# Install predependencies Manually
ansible all --vault-password-file ./password.txt -m apt -a "name=facter state=present update_cache=true" -o $@

echo "running playbook"
# Run playbook.
ansible-playbook all.yml --vault-password-file ./password.txt $@
