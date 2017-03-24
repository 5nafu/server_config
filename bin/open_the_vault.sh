#!/bin/sh
gpg2 --batch --use-agent --decrypt $(git rev-parse --show-toplevel)/vault_passphrase.gpg 2>/dev/null
