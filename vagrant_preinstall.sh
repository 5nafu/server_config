#!/bin/bash

# This is run by vagrant to install python on the debian box

ISDEBIAN=false
declare -a PACKAGES

if [[ -f /etc/debian_version ]]; then
  ISDEBIAN=true
fi

if ! hash python 2>/dev/null; then
  PACKAGES+=("python")
fi

if ! hash facter 2>/dev/null; then
  PACKAGES+=("facter")
fi

if $ISDEBIAN; then
  apt-get update
  apt-get install -y --no-install-recommends ${PACKAGES[*]}
else
  yum -y install ${PACKAGES[*]}
fi
