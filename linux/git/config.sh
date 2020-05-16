#!/bin/bash

# Enable debug output
set -x

# Set you user info
[[ $1 ]] && git config --global user.name "$1"
[[ $2 ]] && git config --global user.email "$2"
 
# Disable ssl verification
#git config --global http.sslVerify false
 
# Push only current branch
git config --global push.default current
 
# Make all future cloned repos to do fetch and rebase on pull (not fetch and merge)
git config --global branch.autosetuprebase always

# Caching credentials
git config --global credential.helper store

# Default editor
git config --global core.editor vim

# Logging
git config --global log.decorate auto

# Setuo BeyondCompare as diff/merge tool
#git config --global diff.tool bc3
#git config --global difftool.bc3.trustExitCode true
#git config --global merge.tool bc3
#git config --global mergetool.bc3.trustExitCode true
