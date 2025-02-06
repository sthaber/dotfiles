#!/bin/bash
set -ex

find $(pwd) -type d -name ".git" -prune -o -type f ! -name install.sh -exec ln -sf {} ~/ \;

crontab ~/.crontab

sudo apt -y install \
     emacs \
     rbenv \
     zile
