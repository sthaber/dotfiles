#!/bin/bash
find ~/patches_backup -type d -mtime +30 -exec rm -rf {} +
