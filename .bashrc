#SETTINGS
export SVN_EDITOR=vim
export LSCOLORS=gxGxxxxxCxxxxxCACEeDeH
export SVN_MERGE=~/bin/mergewrap.sh
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
