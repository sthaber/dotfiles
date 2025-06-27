# Ubuntu's default .bashrc looks for this file, so I'm using that as a way to shim in stuff without
# overriding the default.

export EDITOR="emacs"

export HISTSIZE=1000000
export HISTFILESIZE=1000000

export PATH=/opt/qumulo/toolchain/bin:$PATH:~/.local/bin:~/tools:~/src/tools

# Terminal prompt.
txtblu='\e[1;34m' # Blue
txtrst='\e[0m'    # Text Reset
export PS1="\[$txtblu\][coder \t]\[$txtrst\]\$ "

# Manually force AI terminals to load the VSCode shell integration goop.
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    . "$(cursor --locate-shell-integration-path bash)"
fi

# Build
alias bloop='build --loop'
alias blood='build --loop-until-done'
alias cr='./check_run.py -bc'
alias crr='./check_run.py'
alias rgt='./tools/red_green.py'
alias lac='lint/all -ac'
alias lc='lint/all -c'
alias la='lint/all -a'

# Patch management
alias np='next-patch --qnew'
alias pp='next-patch --prev --qnew'
alias qedit='emacs ~/src/.hg/patches/series'
alias gh='hg'
alias mqdiff='hg diff -r qparent:qtip'
alias mqstat='hg diff --stat -r qparent:qtip'

# Copy from official build
alias cptags='cp -f /mnt/gravytrain/build/latest/src/{tags,TAGS} ~/src'
alias cpra='cp -f /mnt/gravytrain/build/latest/src/rust-project.json ~/src && pkill rust-analyzer'

# Directory shortcuts
alias src='cd ~/src'
alias latest='cd ~/src/build/tmp/latest'
alias failed='cd ~/src/build/tmp/latest/FAILED'
alias debug='less ~/src/build/tmp/latest/**/debug.log'
alias output='less ~/src/build/tmp/latest/**/test_output'

# Toolchain
alias notoolchain='export PATH=$(echo $PATH | sed "s|/opt/qumulo[^:]*:||g")'

# Misc.
alias enzo="source $HOME/src/tools/qston/enzo/enzo.bash"
alias rmjunk='find /home/steven/src/ -name "*.rej" -o -name "*.orig" -o -name "*~" | xargs rm'
alias simkill='tools/kill_stale_simnodes.sh'
alias tn='~/src/triage/triageninja'
alias claude='~/.claude/local/claude'

# Qontent
export GITHUB_TOKEN=$(cat /etc/coder/ghtoken)
export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh-agent.socket
