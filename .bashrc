# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

KERNEL=`uname`

# Let the system level bashrc load in first.
if [ -f /etc/bashrc ]; then 
    . /etc/bashrc
fi

#ALIASES
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias vim="vim -p"

alias resolve="cd \`pwd -P\`"

#FUNCTIONS
function ercho(){
    echo $@ 1>&2
}

# alert" function for long running commands.  Use like so:
#   sleep 10; alert
function alertf(){
    icon=$([ $? = 0 ] && echo terminal || echo error)
    summary="$(history | tail -n1 | sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alertf$//')"
    notify-send --urgency=low -i $icon "$summary"
}

recipesDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"/shrecipes

#Load in smaller recipe files
for recipe in $recipesDir/*.shrc
do
  source $recipe
done

#Let a local bashrc load in last
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

