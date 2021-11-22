#!/bin/sh

[ -z "$PS1" ] && return

HISTCONTROL=ignoredups:ignorespace

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize


[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "$manjaro_chroot" ] && [ -r /etc/manjaro_chroot ]; then
    manjaro_chroot=$(cat /etc/manjaro_chroot)
fi

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac


if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then

	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [ "$EUID" -ne 0 ];
    then PS1="\[\033[0;31m\]\342\224\214\342\224\200\e[m\e[\033[1;31m\u\e[m \e[\033[1;37m\]at\e[m \e[\033[0;33m\]\h \e[\033[1;37m\]in\e[m \e[\033[1;36m\]\w\e[m\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\e[m\[\033[1;34m\][λ] <>\e[m ";

    else
    PS1="\[\033[0;31m\]\342\224\214\342\224\200\e[m\e[\033[1;31mroot\e[m \e[\033[1;37m\]at\e[m \e[\033[0;33m\]\h \e[\033[1;37m\]in\e[m \e[\033[1;36m\]\w\e[m\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\e[m\[\033[1;34m\][λ] <>\e[m ";
    fi

fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm*|rxvt*)
    PS1="\[\033[0;31m\]\342\224\214\342\224\200\e[m\e[\033[1;31m\u\e[m \e[\033[1;37m\]at\e[m \e[\033[0;33m\]\h \e[\033[1;37m\]in\e[m \e[\033[1;36m\]\w\e[m\n\[\033[0;31m\]\342\224\224\342\224\200\342\224\200\e[m\[\033[1;34m\][λ] <>\e[m "

    ;;
*)
    ;;
esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi
