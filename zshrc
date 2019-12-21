# If you come from bash you might have to change your $PATH.
# export PATH=/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/renedevichi/.oh-my-zsh"

export TERM="xterm-256color"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes


ZSH_THEME="powerlevel9k/powerlevel9k"
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(ssh virtualenv dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator background_jobs)


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(docker git rsync tmux)

source $ZSH/oh-my-zsh.sh

compinit

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# note: ESC-h calls run-help
unalias run-help
autoload run-help

# prevent zsh to print an error when no match can be found
unsetopt nomatch

# don't share history
unsetopt share_history

export EDITOR=vim       # nano is for kids
unset LESS		# prevent grep to launch less

export GOPATH=${HOME}/go
export PATH=$PATH:${GOPATH//://bin:}/bin

# handy aliases
if (( $+commands[lsd] )); then
    alias ls='lsd'
    alias ll='lsd -l'
    alias la='lsd -la'
else
    alias ll='ls -l'
    alias la='ls -la'
fi

alias tree='tree -C'
alias top='top -o cpu -O time -s 2 -n 30'

alias gg='git grep -n'
alias ff='find . -name'
alias e='code'
alias enter_docker='docker run --rm -it --privileged --pid=host debian nsenter -t 1 -m -u -n -i sh'
unalias gp  # gp is PARI/GP, not 'git push'

# private tools
[ -d $HOME/.local/bin ] && export PATH="$PATH:$HOME/.local/bin"

# private aliases
[ -f $HOME/.bash_aliases ] && source $HOME/.bash_aliases

# Visual Studio Code wrapper that accepts arguments like "FILENAME:LINE:COLUMN:"
code()
{
    local e=$(whence -p code)

    if [ "${1:0:1}" = - ]; then
        $e $@
    else
        args=()
        for i in $@; do
            typeset -a a
            local a=(${(@s/:/)1})
            local n=${#a[@]}
            shift

            if [ $n -eq 1 ]; then
                args+=("$a[1]")
            elif [ $n -ge 2 ]; then
                if [ -s $a[1] ]; then
                    args+=(-g "$a[1]:$a[2]:$a[3]")
                else
                    echo -e "\033[1;31mError:\033[0m file \033[1;36m$a[1]\033[0m does not exist - ignored"
                fi
            fi
        done
        $e $args
    fi
}

# vim wrapper that accepts argument like "FILENAME:LINE:COLUMN:"
vim()
{
    local e=$(whence -p vim)
    typeset -a arg
    local arg=(${(@s/:/)1})
    local n=${#arg[@]}

    if [ $n -eq 0 ]; then
        $e
    elif [ $n -eq 1 ]; then
        $e $@
    elif [ ! -e $arg[1] ]; then
        echo -e "\033[1;31mError:\033[0m file \033[1;36m$arg[1]\033[0m does not exist"
    else
        shift
        $e $arg[1] +$arg[2] $@
    fi
}


upgrade_env()
{
    pushd $__p9k_root_dir
    git pull --force --verbose
    popd

    upgrade_oh_my_zsh

    brew upgrade
}
