#!/bin/bash

find $(pwd) -maxdepth -type f ! -name install.sh -exec ln -sf {} ~/ \;

crontab ~/.crontab

sudo apt -y install \
     emacs \
     rbenv \
     zile
