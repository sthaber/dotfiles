#!/bin/bash
set -ex

CWD=$(pwd)

find "$CWD" -maxdepth 1 -type f ! -name install.sh -exec ln -sf {} ~/ \;
ln -sf "$CWD"/.ssh/config ~/.ssh/

crontab ~/.crontab

sudo apt -y install emacs zile
