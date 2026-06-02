#!/bin/bash
# Each backup lives at ~/patches_backup/<srcname>/<timestamp>; prune old
# timestamp dirs without removing the per-src parent dirs.
find ~/patches_backup -mindepth 2 -maxdepth 2 -type d -mtime +30 -exec rm -rf {} +
