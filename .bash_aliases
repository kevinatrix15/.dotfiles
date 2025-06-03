#!/usr/bin/env bash
# =================================================================================
# Custom Aliases
# =================================================================================

# Allow colors in 'less'
alias less='/usr/bin/less -r'

# Trim the BASH prompt to a max of 4 directories
export PROMPT_DIRTRIM=4

# Equivalent of double-clicking on a file
alias xo='xdg-open'

# Update all submodules
alias gitsub='git submodule sync --recursive && git submodule update --init --recursive'

# 'Pretty' print of Git log
alias gitlogp='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%C(bold blue) <%an> %Creset" --abbrev-commit'
alias gitlog='git log'

# List all remotes
alias gitremote='git config --list | grep "remote.*url"'

alias gitclone='git clone --recurse-submodules'

# Always use nvim
# alias vim='nvim'

alias nv='nvim ./'

alias nvim-kickstart='NVIM_APPNAME="nvim-kickstart" nvim'
alias nvim-jacob='NVIM_APPNAME="nvim-jacob-lua" nvim'

# ripgrep
alias rgf='rg --files | rg'

# Connect to the Shield office VPN
alias cisco-vpn='/opt/cisco/anyconnect/bin/vpnui' # sdoffice.shield.ai alias nvim=/home/kevin/.local/lib/nvim.appimage

alias cde='cd ~/sai/EdgeAI/'
alias cdb='cd ~/sai/EdgeAI/src/subsystems/behavior_subsystem/'
alias cdee='cd ~/sai/EdgeAI/src/subsystems/executive_manager/'

alias cdhmevbat='cd ~/sai/HivemindEdgeVBAT/'
alias cdhmsdk='cd ~/sai/HivemindSDK/'
alias cdhmesdk='cd ~/sai/HivemindEdgeSDK/'

alias cde-dev='cd ~/sai/EdgeAI/ && code . && shieldup'

alias cdmeteor='cd ~/.meteor'
alias cdmetlatest='cd ~/.meteor && cd $(ls -t ~/.meteor | head -n 1)'

alias clip='xclip -selection clipboard'
alias cliphash='git log | head -n 1 | cut -d " " -f 2 | xclip -selection clipboard'

# Git
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gchk='git checkout'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gf='git fetch'
alias gr='git rebase'
alias gitshow='git show --compact-summary '

# HM SDK
# alias make-dev='make initialize-build pilot'
alias make-dev='make initialize-build conan-package pilot examples'

# HM Workspace
alias hmwi='hm workspace init'
alias hmwb='hm workspace build scenario'
alias hmws='hm workspace sync'
alias hmwrs='hm workspace run start'
alias hmcue='rm -rf build && rm -rf cue.mod/pkg && hmws && hmwb'

alias pk='pkill -f scenario-manage -9 && pkill -f serf -9 && pkill -f edgeos -9'

# Git blame of a directory
blamedir()
{
  FILE_W=35;
  BLAME_FORMAT="%C(auto) %h %ad %C(dim white)%an %C(auto)%s";

  for f in $1*;
  do
    git log -n 10 --pretty="$(printf "%-*s" $FILE_W "$f") $BLAME_FORMAT" -- $f
  done;
};

# git functions
rebase() {
  git checkout master && \
  git fetch origin && \
  git rebase origin/master
}

branchdelete() {
	echo "Are you sure you want to delete ${1}?"
	read -n1 ANS
	if [[ "${ANS}" == "y" ]]; then
		git push origin --delete "${1}"
		git branch -d "${1}"
	fi
}

# --------------------------------------------------------------------------------
# Python Virtual Environment Management
# --------------------------------------------------------------------------------
# Source (creating if needed) a local Python virtual environment, or one from PYTHON_VENV_HOME
venv() {
    PYTHON_VENV_HOME=${HOME}/python-venvs
    if [ $# -gt 1 ]; then
        echo "Expected 0 or 1 arguments"
        echo "usage:"
        echo -e "\tvenv           # Sources local '.venv'"
        echo -e "\tvenv venv_name # Sources venv at '${PYTHON_VENV_HOME}/venv_name'"
        return
    fi
    if [ -n "${VIRTUAL_ENV}" ]; then
      echo "Deactivating current Python virtual environment"
      unset VIRTUAL_ENV & deactivate
    fi
    if [ $# == 0 ]; then
        if [ ! -d .venv ]; then
            echo "Creating Python virtual environment in current directory at .venv"
            python3 -m venv .venv
        fi
        source .venv/bin/activate
    elif [ $# == 1 ]; then
        VENV_DIR=${PYTHON_VENV_HOME}/$1
        if [ ! -d ${VENV_DIR} ]; then
            echo "Creating Python virtual environment at ${VENV_DIR}"
            python3 -m venv ${VENV_DIR}
        fi
        source ${VENV_DIR}/bin/activate
    fi
}

# Autocomplete for the 'venv' function
__venv_complete() {
 PYTHON_VENV_HOME=${HOME}/python-venvs
 if [ "$COMP_CWORD" -ne 1 ]; then
    return 0
 fi
 local comps=""
 for file in ${PYTHON_VENV_HOME}/*
 do
    if [ -d $file ]; then
        comps="${comps} $(basename $file)"
    fi
 done
 COMPREPLY=( $(compgen -W '$comps' -- ${COMP_WORDS[COMP_CWORD]}) )
 return 0
}
complete -F __venv_complete venv


# --------------------------------------------------------------------------------
# dotfiles setup (avoids need for symlinks)
# --------------------------------------------------------------------------------
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'


# --------------------------------------------------------------------------------
# HM SDK Server Installation
# --------------------------------------------------------------------------------
hmserver_reinstall() {
  sudo hm server unbootstrap
  sudo hm server bootstrap
  su - $USER
  hm server install-tenant secondary
  hm server install-apps secondary
  hm server list-tenants
}

# --------------------------------------------------------------------------------
# Matlab
# --------------------------------------------------------------------------------
alias matlab='matlab -softwareopengl'
alias matlab-vbat='cd /home/kevin/sai/VBAT/vbat/wsim && matlab && cd -'

# --------------------------------------------------------------------------------
# Grep TUI Exercises
# --------------------------------------------------------------------------------
alias grepexercises='/home/kevin/source/personal-dev/textual_apps/bin/grepexercises'

# --------------------------------------------------------------------------------
# Fast reset
# --------------------------------------------------------------------------------
alias reset='tput reset'

# --------------------------------------------------------------------------------
# FUN
# --------------------------------------------------------------------------------
alias jokeme='curl -G "https://v2.jokeapi.dev/joke/Pun?format=txt&type=twopart&blacklistFlags=nsfw,religious,political,racist,sexist,explicit" && echo ""'
