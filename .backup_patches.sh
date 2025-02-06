#!/bin/bash
timestamp=$(date +"%Y%m%d_%H%M%S")
mkdir -p ~/patches_backup/$timestamp
cp -r ~/src/.hg/patches/* ~/patches_backup/$timestamp/
