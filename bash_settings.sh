#! /bin/bash
# This file is intended to be sourced in a .bashrc

# default editor: vim
export EDITOR=vim

# hg prompt code
hg_prompt() {
    # some protection to keep up from spamming the console
    # with hg help when there's an error
    OUTPUT=$(hg prompt "({branch}{status})" 2> /dev/null)
    if [[ $? -eq 0 ]]; then
        echo $OUTPUT
    fi
}

# git prompt pieces
COLOR_RED="\033[0;31m"
COLOR_YELLOW="\033[0;33m"
COLOR_GREEN="\033[0;32m"
COLOR_OCHRE="\033[38;5;95m"
COLOR_BLUE="\033[0;34m"
COLOR_WHITE="\033[0;37m"
COLOR_RESET="\033[0m"

git_color() {
  local git_status="$(git status 2> /dev/null)"

  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $COLOR_RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $COLOR_YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $COLOR_GREEN
  else
    echo -e $COLOR_OCHRE
  fi
}

color_reset() {
    echo -e $COLOR_RESET
}

git_branch() {
  local git_status="$(git status 2> /dev/null)"
  local on_branch="On branch ([^${IFS}]*)"
  local on_commit="HEAD detached at ([^${IFS}]*)"

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  fi
}

git_prompt() {
    echo "$(git_color)$(git_branch)$(color_reset)"
}

# override the terminal prompt with hg and git status pieces
export PS1='\h:\w $(hg_prompt)$(git_prompt)$ '

# modify mysql prompt to have database name
export MYSQL_PS1="[\d]> "
