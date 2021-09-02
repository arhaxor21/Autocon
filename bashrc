#These is not the default aliases. These aliases are modified and automated some commands///
#Do check out the commands here///

case $- in
*i*) ;;
*) return ;;
esac

HISTCONTROL=ignoreboth

shopt -s histappend

HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
xterm-color) color_prompt=yes ;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

case "$TERM" in
xterm* | rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*) ;;

esac

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi


#aliases (In these aliases u can modify your command aliases)
alias cls='clear'
alias myip='ifconfig | grep "inet"'
alias locip='curl ipinfo.io/ip'
alias netreset='service NetworkManager restart'
alias apstart='service apache2 start'
alias apstop='service apache2 stop'
alias sshstart='service ssh start'
alias sshstop='service ssh stop'
alias pyserver='python -m SimpleHTTPServer'
alias svstatus='service --status-all' 
alias st='speedtest'
alias open='xdg-open'
alias ff='firefox'
alias lp='leafpad'
alias update='apt update && apt upgrade'
alias cls-his='echo " " > ~/.zsh_history' 
alias profile='subl ~/.zshrc'
alias sc='source ~/.zshrc'
alias open-ports='lsof -i -P -n | grep LISTEN'
alias vpnstop='service openvpn stop'
alias burp='./.burp.sh'
alias vpnstart='service openvpn start'
alias zprofile='subl ~/.zprofile '
alias zsc='source ~/.zprofile'

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
