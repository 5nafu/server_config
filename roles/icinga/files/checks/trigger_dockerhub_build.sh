#!/bin/bash

while getopts "s:t:a:R:T:" opt; do
  case $opt in
    s)
      servicestate=$OPTARG
      ;;
    t)
      servicestatetype=$OPTARG
      ;;
    a)
      serviceattempt=$OPTARG
      ;;
    R)
      repository=$OPTARG
      ;;
    T)
      token=$OPTARG
      ;;
  esac
done

if ( [ -z $servicestate ] || [ -z $servicestatetype ] || [ -z $serviceattempt ] || [ -z $repository ] || [ -z $token ] ); then
  echo "USAGE: $0 -s servicestate -t servicestatetype -a serviceattempt -R dockerhub_repository -T webhook_trigger"
  exit 3;
else
  echo "$(date -Is) Event: servicestate=$servicestate // servicestatetype=$servicestatetype // serviceattempt=$serviceattempt // repository=$repository // token=$token" >/tmp/trigger_dockerhub_build.log
  # Only restart on the first attempt of a critical event
  if ( [ $servicestate == "CRITICAL" ] && [ $servicestatetype == "HARD" ] && [ $serviceattempt -eq 1 ] ); then
    curl -H "Content-Type: application/json" --data '{"build": true}' -X POST "https://registry.hub.docker.com/u/$repository/trigger/$token/"
    echo "Triggered" >> /tmp/trigger_dockerhub_build.log
  else
    echo "skipped" >> /tmp/trigger_dockerhub_build.log
  fi
fi
