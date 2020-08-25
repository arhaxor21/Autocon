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
alias ip='ifconfig'
alias locip='curl ipinfo.io/ip'
alias netreset='service network-manager restart'
alias apstart='service apache2 start'
alias apstop='service apache2 stop'
alias sshstart='service ssh start'
alias sshstop='service ssh stop'
alias pyserver='python -m SimpleHTTPServer'
alias svstatus='service --status-all'

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

# recon automation scripts here if u want that u can modify for your use
# Just modify the script and again this to the source in your source file

#----- AWS -------

s3ls(){
aws s3 ls s3://$ip
}

s3cp(){
aws s3 cp $2 s3://$ip 
}

#---- Content discovery ----
thewadl(){ #this grabs endpoints from a application.wadl and puts them in yahooapi.txt
curl -s $ip | grep path | sed -n "s/.*resource path=\"\(.*\)\".*/\1/p" | tee -a ~/recon/dirsearch/db/yahooapi.txt
}

#----- recon -----
crtndstry(){
./recon/crtndstry/crtndstry $ip
}

am(){ #runs amass passively and saves to json
amass enum --passive -d $ip -json $ip.json
jq .name $ip.json | sed "s/\"//g"| httprobe -c 60 | tee -a $ip-domains.txt
}

certprobe(){ #runs httprobe on all the hosts from certspotter
curl -s https://crt.sh/\?q\=\%.$ip\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe | tee -a ./all.txt
}

mscan(){ #runs masscan
sudo masscan -p4443,2075,2076,6443,3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,744$}
}

certspotter(){ 
curl -s https://certspotter.com/api/v0/certs\?domain\=$ip | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $ip
} #h/t Michiel Prins

crtsh(){
curl -s https://crt.sh/?Identity=%.$ip | grep ">*.$ip" | sed 's/<[/]*[TB][DR]>/\n/g' | grep -vE "<|^[\*]*[\.]*$ip" | sort -u | awk 'NF'
}

certnmap(){
curl https://certspotter.com/api/v0/certs\?domain\=$ip | jq '.[].dns_names[]' | sed 's/\"//g' | sed 's/\*\.//g' | sort -u | grep $ip  | nmap -T5 -Pn -sS -i - -$
} #h/t Jobert Abma

ipinfo(){
curl http://ipinfo.io/$ip
}


#------ recon ------
dirsearch(){ runs dirsearch and takes host and extension as arguments
python3 ~/recon/dirsearch/dirsearch.py -u $ip -e $2 -t 50 -b 
}

sqlmap(){
python ~/recon/sqlmap*/sqlmap.py -u $ip 
}

ncx(){
nc -l -n -vv -p $ip -k
}

crtshdirsearch(){ #gets all domains from crtsh, runs httprobe and then dir bruteforcers
curl -s https://crt.sh/?q\=%.$ip\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | httprobe -c 50 | grep https | xargs -n1 -I{} python3 ~/recon/dirsearch/dirsearch.py -u {} -e $2 -t 50 -b 
}


