# .bash_profile

## .bash_profile for Ubuntu
## Author : Matias Barrios
## Year : 2017

# Get the aliases and functions

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export GOPATH='/home/matias/go'
export GOROOT='/usr/local/go'
export GOBIN='/home/matias/go/bin'
export PATH="$PATH:$GOBIN:$GOROOT"

alias ls='ls -Gfh'
alias ll='ls -Gfhla'

LC_ALL='en_US.UTF-8'
LC_CTYPE='en_US.UTF-8'

function DECLARE_COLORS() {
	
	#################################
	###  Color for terminal
	#################################
	## NORMAL
	export NORMAL=$(tput sgr0)
	
	## FOREGROUND
	export FGBLACK=$(tput setaf 0)
	export FGRED=$(tput setaf 1)
	export FGGREEN=$(tput setaf 2)
	export FGYELLOW=$(tput setaf 3)
	export FGBLUE=$(tput setaf 4)
	export FGMAGENTA=$(tput setaf 5)
	export FGCYAN=$(tput setaf 6)
	export FGWHITE=$(tput setaf 7)
	export FGBRIGHT=$(tput bold)
	export FGNORMAL=$(tput sgr0)
	export FGBOLD=$(tput bold)
	
	## BACKGROUND
	export BGBLACK=$(tput setab 0)
	export BGRED=$(tput setab 1)
	export BGGREEN=$(tput setab 2)
	export BGYELLOW=$(tput setab 3)
	export BGBLUE=$(tput setab 4)
	export BGMAGENTA=$(tput setab 5)
	export BGCYAN=$(tput setab 6)
	export BGWHITE=$(tput setab 7)
	
	## SHAPE
	export SHUNDERLINE=$(tput smul)
	export SHBOLD=$(tput bold)
	export SHSBOLD=$(tput smso)
}
DECLARE_COLORS

function BASIC_HC() {
	printf "${FGYELLOW}Host : ${NORMAL}${FGGREN}$( hostname )${NORMAL}\n";
	printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
	printf "${FGYELLOW}Uptime : ${NORMAL}${FGGREEN}%s${NORMAL}\n" "$( uptime )";
	printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
	printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
        printf "${FGYELLOW}ROFS : \n${NORMAL}${FGGREEN}%s${NORMAL}\n" "$( grep -w ro /proc/mounts )";
        printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;	
	printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
        printf "${FGYELLOW}Last Reboot:\n${NORMAL}${FGGREEN}%s${NORMAL}\n" "$( last reboot)";
        printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;	
	printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
        printf "${FGYELLOW}Disk Utilization:\n${NORMAL}${FGGREEN}%s${NORMAL}\n" "$( df -h)" ;
        printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;   
	printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
        printf "${FGYELLOW}Devices:\n${NORMAL}${FGGREEN}%s${NORMAL}\n" "$(lsscsi)";
        printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
	printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
        printf "${FGYELLOW}lsblk:\n${NORMAL}${FGGREEN}%s${NORMAL}\n" "$(lsblk)";
        printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
	printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
        printf "${FGYELLOW}dmesg (Check manually anyway!):\n${NORMAL}${FGGREEN}%s${NORMAL}\n" "$( dmesg | grep -E -i '(error|I/O|uncorrectable)' )";
        printf "${FGBLUE}";printf "%.1s" '='{1..50} $'\n' ;printf "${NORMAL}" ;
}

function SMART-ALL() {
	[[ $# -eq 0 ]] && { echo "At least one argument is needed"; return 1;}
	for i in $@;
	do 
		echo "----------Device : /dev/sd$i-------------"; 
		sudo smartctl -x /dev/sd$i | grep -i -E '^Device Model|^Serial Number|^LU WWN Device Id|^Firmware Version|^User Capacity|overall-health' ; 
		echo  "------------------------------";  
	done;
}

function SSSH() {
	ssh -t $@ "
		$( declare -f SMART-ALL);  
		$( declare -f BASIC_HC);
		$( declare -f DECLARE_COLORS);
		$( declare -f CHECK_BIGGEST_FOLDERS);
		$( declare -f CHECK_BIGGEST_FILES);
        $( declare -f CURL_TIME);
		DECLARE_COLORS;
		export -f SMART-ALL BASIC_HC DECLARE_COLORS CURL_TIME; 
		export -f CHECK_BIGGEST_FOLDERS CHECK_BIGGEST_FILES;
		PROMPT_COMMAND='export PS1=\"\[\e[37;46m\]\h\[\e[m\]\[\e[37;46m\]@\[\e[m\]\[\e[37;42m\]:\[\e[m\]\[\e[42m\]\W\[\e[m\]\[\e[30;43m\]\\$\[\e[m\]  \" bash -li; " 

}


GIT_BRANCH() {
  status=$?	
  branch=$( git branch 2>/dev/null | grep '^*' | colrm 1 2 )
  [[ ! -z "$branch" ]] && printf "($branch)" || printf ""
  return $status
}

GIT_PUSH() {
  local branch_name=$1
  if [[ -z "$branch_name" || ! "$branch_name" =~ [a-zA-Z0-9_-]{6,} ]]
  then
    printf "\n\t ${RED} Provide a valid ${YELLOW}branch${RED} name!!${NORMAL}\n\n"
    return
  fi
  git add -A . && git commit -m "$branch_name" && git push origin "$branch_name"
}

CURL_TIME() {
    curl -k -w "\n\n\n\
   namelookup:  %{time_namelookup}s\n\
      connect:  %{time_connect}s\n\
   appconnect:  %{time_appconnect}s\n\
  pretransfer:  %{time_pretransfer}s\n\
     redirect:  %{time_redirect}s\n\
starttransfer:  %{time_starttransfer}s\n\
-------------------------\n\
        total:  %{time_total}s\n" "$@"
}

function CHECK_BIGGEST_FOLDERS() {
	[[ $# -ne 2 ]] && { printf "You need to pass ${FGCYAN}two${FGNORMAL} arguments.\n${FGYELLOW}1${FGNORMAL} : Starting path, for instance ${FGYELLOW}/var${FGNORMAL}\n${FGYELLOW}2${FGNORMAL} : A number of results you want. For instance ${FGYELLOW}10${FGNORMAL}\n"; return 1;}
	[[ ! "$2" =~ [1-9][0-9]? ]] && { printf "Your second argument does ${FGRED}not${FGNORMAL} look like a ${FGRED}number${FGNORMAL}.\n" ; return 2; }
	sudo find "$1" -type d -exec du -sh {} \; | sort -rh | head -"$2"
}

function CHECK_BIGGEST_FILES() {
	[[ $# -ne 2 ]] && { printf "You need to pass ${FGCYAN}two${FGNORMAL} arguments.\n${FGYELLOW}1${FGNORMAL} : Starting path, for instance ${FGYELLOW}/var${FGNORMAL}\n${FGYELLOW}2${FGNORMAL} : A number of results you want. For instance ${FGYELLOW}10${FGNORMAL}\n"; return 1;}
	[[ ! "$2" =~ [1-9][0-9]? ]] && { printf "Your second argument does ${FGRED}not${FGNORMAL} look like a ${FGRED}number${FGNORMAL}.\n" ; return 2; }
	sudo find "$1" -type f -exec du -sh {} \; | sort -rh | head -"$2"
}

function statusCode() {
	[[ $? -eq 0 ]] && printf '\001\e[31m\002('$?')\001\e[m\002'
	[[ $? -ne 0 ]] && printf '\001\e[31m\002('$?')\001\e[m\002'
}


# Prompt as in GitBash
export PS1="\[\e[32m\][\[\e[m\]\[\e[36m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]@\[\e[35m\]\h\[\e[m\] \[\e[33m\]\$( GIT_BRANCH ) \[\e[m\]\n\$( statusCode ) \[\e[34m\]\u\[\e[m\] \[\e[32m\]#>\[\e[m\] "


if [[ "$( date '+%D' )" != "$(cat ~/.lastrun_bash_profile 2>/dev/null)" ]]
then
        clear
	# Once a day stuff
fi


