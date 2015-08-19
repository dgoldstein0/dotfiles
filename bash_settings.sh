#! /bin/bash
# This file is intended to be sourced in a .bashrc

# default editor: vim
export EDITOR=vim

# source control prompt
source_prompt() {
    git rev-parse >& /dev/null;
    if [[ $? ]]; then
        echo $(git_prompt);
    else
        echo $(hg_prompt);
    fi
}

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
    # the color characters are surrounded in \001 and \002 to tell
    # bash that these characters are non-printable, so should be excluded
    # for the purposes of line-wrapping calculations.  Usually we'd use \[
    # and \], but, echo (and echo -e) don't understand these.  the -e is
    # because we want echo to parse \001 and \002 as control characters.
    #
    # source:
    # http://stackoverflow.com/questions/19092488/custom-bash-prompt-is-overwriting-itself
    echo -e "\001$(git_color)\002$(git_branch)\001$(color_reset)\002"
}

# override the terminal prompt with hg and git status pieces
# start with \r to reset to the beginning of the line, in case some input has
# been typed before the prompt shows - as it throws off line wrapping if allowed
# to linger, and will always be reprinted after the prompt displays anyway.
# \[ and \] mark \r as non-printable so that the terminal doesn't include it in
# the count for line wrapping (or assume we will do our own wrapping).
# \h is the host and \w is the current directory.
export PS1='\[\r\]\h:\w $(source_prompt)$ '

# modify mysql prompt to have database name
export MYSQL_PS1="[\d]> "
