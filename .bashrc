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
function svndiff(){
    vimdiff $6 $7
}
function ercho(){
    echo $@ 1>&2
}
function codebase(){
    grep -irl "$1" . 2>/dev/null | grep -v /\.svn/| xargs -n1 grep -iHn "$1"
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

function diff(){ 
    file=${!#} 
    tmpfile=/tmp/repo/${!#} 
    mkdir -p `dirname $tmpfile` 
    svn cat -rHEAD $@ > $tmpfile 
    vimdiff $file $tmpfile 
    ret=$?
    rm -rf /tmp/repo/ 
    return $ret
}

function commit(){ 
    if [ -n "type -t pre_commit_check" ]
    then
        if pre_commit_check $@
        then
            :
        else
            return 1
        fi
    fi

    msg=''
    if [ -n "type -t get_commit_message" ]
    then
        msg="`get_commit_message $@`"
    else 
        msg="$@"
    fi
        
    if [[ "$@" == "" ]]; then
        ercho "Must Provide a commit Message"
        return
    fi
    echo "Updating repository...";
    svn update
    if [ $? != 0 ] #Update failure
    then
        return
    fi
    for x in `svn stat | sed "s/^[^M].*$//" | sed "s/^M//"` 
    do 
        diff $x 
        if [ $? != 0 ]
        then
            return
        fi
    done 
    echo "New Files:" 
    svn stat | grep ^A | awk '{print " ", $2}'
    echo "Deleted Files:" 
    svn stat | grep ^D | awk '{print " ", $2}'
    echo "Modified Directories:" 
    svn stat | grep "^ M" | awk '{print " ", $2}'
    echo -e "\n$msg"
    read -ep "Continue with Commit (Y/n)? " approve 
    approve=`echo $approve` #Trim whitespace. 
    if [ "$approve" != "" -a "${approve:0:1}" != "y" -a "${approve:0:1}" != "Y" ] 
    then 
    return 
    fi 
    svn ci -m "$msg" 
    svn up
    svn log -v --limit 1

    if [ -n "type -t post_commit" ]
    then
        post_commit $@
    fi
}

function vdiff(){
    fname=$1
    shift
    files=""
    while (( "$#" ))
    do
        if [[ "$1" == "_" ]]
        then
            files="$files $fname"
        else 
            tmpfile="/tmp/repo/$1/$fname"
            mkdir -p `dirname $tmpfile`
            svn cat $fname@$1 > $tmpfile 
            files="$files $tmpfile"
        fi
        shift
    done
    vimdiff $files
    ret=$?
    rm -rf /tmp/repo
    return $ret
}

function diffsteplist(){
    while (( $# > 1 ));
    do
        vimdiff $1 $2
        if (( $? != 0 ))
        then
            return
        fi
        shift
    done
}

function vdiffstep(){
    fname=$1
    shift
    files=""
    while (( "$#" ))
    do
        if [[ "$1" == "_" ]]
        then
            files="$files $fname"
        else 
            tmpfile="/tmp/repo/$1/$fname"
            mkdir -p `dirname $tmpfile`
            svn cat $fname@$1 > $tmpfile 
            files="$files $tmpfile"
        fi
        shift
    done
    diffsteplist $files
    rm -rf /tmp/repo
}

function vdiffrange(){
    fname=$1
    start=$2
    end=$3
    revisions=`svn log -r$start:$end $fname | grep -o "^r[0-9]\+ |" | sed 's/[^0-9]//g'`
    vdiff $fname $revisions $4
}

function vdiffrangestep(){
    fname=$1
    start=$2
    end=$3
    revisions=`svn log -r$start:$end $fname | grep -o "^r[0-9]\+ |" | sed 's/[^0-9]//g'`
    vdiffstep $fname $revisions $4
}

function versionDiff(){
    fname=""
    versions=""
    step=""
    range=""
    while (( "$#" ))
    do
        if [[ "$1" == "-r" || "$1" == "-R" ]]
        then
            range="Y"
        elif [[ "$1" == "-s" || "$1" == "-S" ]]
        then 
            step="Y"
        elif [[ "$1" == "-rs" || "$1" == "-RS" || "$1" == "-Rs" || "$1" == "-rS" ]]
        then
            step="Y"
            range="Y"
        elif [[ "$fname" == "" ]]
        then
            fname=$1
        else
            versions="$versions $1"
        fi
        shift
    done
    if [[ "$step" = "Y" ]]
    then
        if [[ "$range" == "Y" ]]
        then
            vdiffrangestep $fname $versions
        else
            vdiffstep $fname $versions
        fi
    else
        if [[ "$range" == "Y" ]]
        then
            vdiffrange $fname $versions
        else
            vdiff $fname $versions
        fi
    fi
}
