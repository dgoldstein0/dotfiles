#! /bin/bash
# This file is intended to be sourced in a .bashrc

# default editor: vim
export EDITOR=vim

if [[ $(uname) != "Linux" ]]; then
    # make python work as a REPL in git-bash (windows)
    function do_python() {
        if [ $# -eq 0 ]; then
            python.exe -i
        else
            python.exe $@
        fi
    }
    alias python=do_python
fi

# source control prompt
source_prompt() {
    git rev-parse >& /dev/null;
    if [[ $? = 0 ]]; then
        echo $(git_prompt);
    else
        echo $(hg_prompt);
    fi
}

find_dir() {
    # split current path and check if any level has a $1.
    # this skips /$1 because who will make their top level an hg repo?
    # to fix that case, parts needs to start with an empty string as the
    # first item.
    # pwd -P = current working direct, symlinks resolved
    local parts=$(echo $(pwd -P) | tr "/" "\n")
    local dir=''
    for part in $parts;
    do
        dir=$dir"/"$part
        # exit early if we have a symlink in our path.
        # following symlinks can get us in a lot of trouble.  In particular,
        # navigating around a bazel-bin folder seems to cause trouble because
        # bazel-bin contains a copy of .git but the folder has massively
        # different contents than the repo so git status is slow (and inaccurate)
        # because it ends up with too much to report.
        if [[ -L $dir"/$1" ]]; then
            return 1
        elif [[ -d $dir"/$1" ]]; then
            return 0 # 0 is true
        fi
    done
    return 1
}

# hg prompt code
hg_prompt() {
    # custom find_hg because calling hg prompt is slow so we want to avoid it
    # outside of an hg repo.  It looks like most of the time to call hg prompt
    # is python init, so you probably can't find a signficantly faster hg command.
    if find_dir ".hg"; then
        # some protection to keep up from spamming the console
        # with hg help when there's an error
        OUTPUT=$(hg prompt "({branch}{status})" 2> /dev/null)
        if [[ $? -eq 0 ]]; then
            echo $OUTPUT
        fi
    fi;
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
  # expected git status output as first parameter
  local git_status=$1
  if [[ (! $git_status =~ "working directory clean") && (! $git_status =~ "working tree clean")]]; then
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

function git_branch() {
  # expected git status output as first parameter
  local git_status="$1";
  local on_branch="On branch ([^${IFS}]*)";
  local on_commit="HEAD detached at ([^${IFS}]*)";

  if [[ $git_status =~ $on_branch ]]; then
    local branch=${BASH_REMATCH[1]}
    echo "($branch)"
  elif [[ $git_status =~ $on_commit ]]; then
    local commit=${BASH_REMATCH[1]}
    echo "($commit)"
  fi
}

git_prompt() {
    if find_dir ".git"; then
        # the color characters are surrounded in \001 and \002 to tell
        # bash that these characters are non-printable, so should be excluded
        # for the purposes of line-wrapping calculations.  Usually we'd use \[
        # and \], but, echo (and echo -e) don't understand these.  the -e is
        # because we want echo to parse \001 and \002 as control characters.
        #
        # source:
        # http://stackoverflow.com/questions/19092488/custom-bash-prompt-is-overwriting-itself

        # only fetch git status once for perf
        local git_status="$(git status --ignore-submodules=all 2> /dev/null)"
        echo -e "\001$(git_color \\"$git_status\\")\002$(git_branch \\"$git_status\\")\001$(color_reset)\002"
    fi
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

source ~/.bash_alias.sh

