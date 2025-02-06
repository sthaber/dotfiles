# Ubuntu's default .bashrc looks for this file, so I'm using that as a way to shim in stuff without
# overriding the default.

export EDITOR="emacs"

# Set path and clean up duplicate path entries.
eval $(cat /etc/environment)
PATH=/opt/qumulo/toolchain/bin:$PATH:~/.local/bin:~/tools:~/src/tools

# Terminal prompt.
txtblu='\e[1;34m' # Blue
txtrst='\e[0m'    # Text Reset
export PS1="\[$txtblu\][coder \t]\[$txtrst\]\$ "

alias qedit='emacs ~/src/.hg/patches/series'
alias cr='./check_run.py -bc'
alias crr='./check_run.py'
alias crfw='cr -Q --quark-broker quark-broker-cfw'
alias rgt='./tools/red_green.py'
alias rmjunk='find /home/steven/src/ -name "*.rej" -o -name "*.orig" -o -name "*~" | xargs rm'
alias gh='hg'
alias enzo="source $HOME/src/tools/qston/enzo/enzo.bash"
alias mqdiff='hg diff -r qparent:qtip'
alias mqstat='hg diff --stat -r qparent:qtip'
alias reimage='~/src/check/systest/hw_reimage.py'
alias simkill='tools/kill_stale_simnodes.sh'
alias pyc='lint/pycheck -ca'
alias lac='lint/all -ca'
alias src='cd ~/src'
alias latest='cd ~/src/build/tmp/latest'
alias failed='cd ~/src/build/tmp/latest/FAILED'
alias debug='less ~/src/build/tmp/latest/**/debug.log'
alias output='less ~/src/build/tmp/latest/**/test_output'
alias cptags='cp -f /mnt/gravytrain/build/latest/src/{tags,TAGS} ~/src'
alias np='next-patch'
alias sshi='chmod 0600 ~/src/infrastructure/id_rsa; ssh -i ~/src/infrastructure/id_rsa'
alias scpi='chmod 0600 ~/src/infrastructure/id_rsa; scp -i ~/src/infrastructure/id_rsa'
alias bp='~/backup_patches.sh'

# Qontent
PATH=$PATH:~/.rbenv/bin
eval "$(rbenv init -)"
export GITHUB_TOKEN=$(cat /etc/coder/ghtoken)
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
