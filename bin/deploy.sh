#!/bin/bash

install_linux() {
    if [ -f /etc/debian_version ] ; then
        if [ "$(lsb_release -is)" == "Ubuntu" ]; then
            sudo apt-add-repository ppa:ansible/ansible
        else
            echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" | sudo tee /etc/apt/sources.list.d/ansible-ubuntu-ansible-xenial.list
            sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
        fi
        sudo apt-get update
        sudo apt-get install -y ansible
    elif [ -f /etc/redhat-release ] ; then
        sudo yum install ansible
    else
      echo "Unsupported Linux Distro!" >&2
      return 2
    fi
}

command -v ansible >/dev/null 2>&1 || {
  echo "Installing predependencies on master"
  if [ "${uname -s}" == "Linux" ]; then
    install_linux || exit
  else
    echo "Unsupported Plattform. Please install ansible manually." >&2
    exit
  fi
}

# Go to git root
cd "$( dirname "${BASH_SOURCE[0]}" )"
cd $(git rev-parse --show-toplevel)

git pull

echo "Installing predependencies"
# Install predependencies Manually
ansible all -m apt -a "name=facter state=present update_cache=true" -o $@

echo "running playbook"
# Run playbook.
ansible-playbook all.yml $@
