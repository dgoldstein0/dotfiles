# This script starts an ssh-agent if none currently is running.
# this way, opening / closing shells doesn't leak ssh-agent processes.
# It doesn't kill the process when the last shell is closed, but I
# don't care at the moment.
# This is borrowed from http://mah.everybody.org/docs/ssh which
# attributes it to http://www.cygwin.com/ml/cygwin/2001-06/msg00537.html

SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi
