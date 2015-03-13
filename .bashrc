# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

alias ls='ls --color=auto'
#alias dir='dir --color=auto'
#alias vdir='vdir --color=auto'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

#SETTINGS
export SVN_EDITOR=vim
export LSCOLORS=gxGxxxxxCxxxxxCACEeDeH
export SVN_MERGE=~/bin/mergewrap.sh
export EDITOR=vim
export PS1='
\[\e[0;33m\]\h\[\e[1;36m\][\w/]\[\e[m\]
\[\e[1;34m\]\d, \t\[\e[m\]|\[\e[0;32m\]\u\[\e[m\]\[\e[0;33m\][\!]\[\e[m\]$ '

#ALIASES
alias vim="vim -p"
alias resolve="cd \`pwd -P\`"
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

if [ -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

#FUNCTIONS
function ercho(){
    echo $@ 1>&2
}
function codebase(){
    grep -irl "$1" . 2>/dev/null | grep -v '/\.svn/'| xargs -n1 grep -iHn "$1"
}

function newHost(){
    sudo -v
    #if [ "$(id -u)" != "0" ]; then
    #    echo "This script must be run as root" 1>&2
    #    return
    #fi
    hostname=$1
    if [[ "$hostname" == "" ]]
    then
        echo "Requires one argument:  Host name."
        return
    fi
    mkdir -p $VHOST_FILES/$hostname/public
    printf "<html>
    <head>
        <title>$hostname Landing Page</title>
    </head>
    <body>
        <h1>Hello, World!</h1>
    </body>
</html>" > $VHOST_FILES/$hostname/public/index.html
    printf "
127.0.0.1	$hostname
fe80::1%%lo0	$hostname
" >> /etc/hosts
    echo "printf '
<VirtualHost *:80>
	ServerAdmin webmaster@$hostname
	DocumentRoot \"$VHOST_FILES/$hostname/public\"
	ServerName $hostname
	ErrorLog \"logs/$hostname-error_log\"
	CustomLog \"logs/$hostname-access_log\" common
	<Directory $VHOST_FILES/$hostname/public>
	AllowOverride All
	Options +Indexes
	</Directory>
</VirtualHost>

' >> $VHOST_CONF" | sudo -s
    sudo $VHOST_STOP
    sudo $VHOST_START
}
