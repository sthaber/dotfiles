#!/bin/bash
set -ex

find $(pwd) -type f ! -name install.sh -exec ln -sf {} ~/ \;

crontab ~/.crontab

sudo apt -y install \
     emacs \
     rbenv \
     zile
