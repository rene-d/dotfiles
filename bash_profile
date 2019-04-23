# .bash_profile
# macOS 10.14.1

export EDITOR=vim
#export PATH="$PATH:/usr/local/sbin"

alias ls='ls -G'
alias ll='ls -Gl'
alias la='ls -Gla'
alias tree='tree -C'

alias top='top -o cpu -O time -s 2 -n 30'
alias cfmt='clang-format -i -style="{ BasedOnStyle: LLVM, UseTab: Never, IndentWidth: 4, TabWidth: 4, BreakBeforeBraces: Allman, AllowShortIfStatementsOnASingleLine: false, IndentCaseLabels: false, ColumnLimit: 0 }"'

#shopt -s globstar
export HISTSIZE=20000

# private tools
[ -d $HOME/.local/bin ] && export PATH="$PATH:$HOME/.local/bin"

# private aliases
[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases

[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion

source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash
source /Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh

export PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w\[\033[01;33m\]$(__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '
# export PS1='\[\033[01;32m\]\h:\[\033[01;34m\]\W \u\[\033[01;33m\]$(__git_ps1)\[\033[01;34m\] \$\[\033[00m\] '
export GIT_PS1_SHOWDIRTYSTATE=1

config_git_alias()
{
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
    if [ -z "$(git config --global --get user.name)" ]; then
        git config --global user.name "$(id -un)"
        git config --global user.email "$(id -un)@$(hostname)"
        git config --global --edit
    fi
}

alias gg='git grep -n'
alias ff='find . -name'
alias e='code'

# wrapper à Visual Studio Code pour accepter les arguments du genre "CHEMIN:LIGNE:COLONNE:"
code()
{
    local e=$(which code)

    if [ "${1:0:1}" = - ]; then
        $e $@
    else
        local args=""
        for i in $@; do
            local a=(${i//:/ })
            local n=${#a[@]}

            if [ $n -eq 1 ]; then
                args="$args ${a[0]}"
            elif [ $n -ge 2 ]; then
                if [ -s ${a[0]} ]; then
                    args="$args -g ${a[0]}:${a[1]}:${a[2]}"
                else
                    echo "${FUNCNAME[0]}: Erreur: le fichier ${a[0]} n'existe pas"
                    return
                fi
            fi
        done
        $e $args
    fi
}

# wrapper à vim pour accepter les arguments du genre "CHEMIN:LIGNE:COLONNE:"
vim()
{
    local e=$(which vim)
    local arg=(${1//:/ })
    local n=${#arg[@]}

    if [ ! -e "${arg[0]}" -o $n -eq 0 ]; then
        $e $@
    elif [ $n -eq 1 ]; then
        shift
        $e ${arg[0]} $@
    elif [ $n -ge 2 ]; then
        shift
        $e ${arg[0]} +${arg[1]} $@
    fi
}


# fonction interne pour gga: affiche un git grep -l avec le nom complet du fichier
_gga()
{
    local COLOR_YELLOW=""
    local COLOR_END=""

    if [ -t 1 -a -t 0 ]; then
        COLOR_YELLOW="\033[1;33m"
        COLOR_END="\033[0m"
    fi
    echo
    local p="$(cd $1; pwd)"
    shift
    local args=$@
    git -C $p grep --color -n $args 2>/dev/null | while read -r line ; do echo -e "${COLOR_YELLOW}$p/${COLOR_END}$line" ; done
}

# git grep sur plusieurs dépôts (ou tout le dépôt courant)
gga()
{
    if [ "$*" == "-h" ]; then
        echo "Usage: gga [OPTIONS] MOTIF"
        echo
        echo "Effectue un git grep dans le dépôt entier."
        echo
        echo "git grep -h pour les OPTIONS"
        return 0
    fi

    # dépôt courant
    _gga "$(git rev-parse --show-toplevel)" $@

    # ALT: mettre ici la liste des projets
    # _gga ${HOME}/Projects/project1 $@
    # _gga ${HOME}/Projects/project2 $@
}

# ouvre les résultats de git grep dans l'éditeur
gge()
{
    for i in $(git grep -n $@ | cut -f1,2 -d:); do
        code -g $i
    done
}

# active un virtualenv python
activate()
{
    local prompt=''
    if [ "$1" = "" ]; then
        echo "Missing virtualenv."
        return 1
    fi
    if [ "$1" = "-s" ]; then
        prompt=1
        shift
    fi
    if [ "$2" = "-s" ]; then
        prompt=1
    fi
    if [ ! -d $HOME/.venv/$1 ]; then
        echo "No such venv: $1"
        return 2
    fi
    VIRTUAL_ENV_DISABLE_PROMPT=${prompt} source $HOME/.venv/$1/bin/activate
    echo "Virtualenv for $(python -V) activated."
}

_activate_completions()
{
    # # use 'tty' into a terminal to get its device
    # local log=/dev/ttys001
    # clear > $log
    # echo "#=${#COMP_WORDS[@]}"  >> $log
    # echo "<${COMP_WORDS[@]}>"  >> $log
    # for i in "${!COMP_WORDS[@]}"; do
    #     echo "$i = ${COMP_WORDS[$i]}" >> $log
    # done
    # echo > $log

    if [ ${#COMP_WORDS[@]} -ne 2 ]; then return; fi
    #COMPREPLY=($(cd $HOME/.venv; compgen -A directory -- "${COMP_WORDS[1]}"))
    COMPREPLY=($(cd $HOME/.venv; compgen -o dirnames -- "${COMP_WORDS[1]}"))
}

complete -F _activate_completions activate
