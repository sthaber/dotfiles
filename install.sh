#!/bin/bash

find $(pwd) -maxdepth -type f -exec ln -sf {} ~/ \;

sudo apt -y install \
     emacs \
     rbenv \
     zile
