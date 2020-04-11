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


### My functions

GIT_BRANCH() {
  branch=$( git branch 2>/dev/null | grep '^*' | colrm 1 2 )
  [[ ! -z "$branch" ]] && printf "($branch)" || printf ""
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

curl_time() {
    curl -vk -w "\n\n\n\
   namelookup:  %{time_namelookup}s\n\
      connect:  %{time_connect}s\n\
   appconnect:  %{time_appconnect}s\n\
  pretransfer:  %{time_pretransfer}s\n\
     redirect:  %{time_redirect}s\n\
starttransfer:  %{time_starttransfer}s\n\
-------------------------\n\
        total:  %{time_total}s\n" "$@"
}

###clear
#echo "${FGGREEN}**************************************${NORMAL}"
#echo "${FGGREEN}*                                    *${NORMAL}"
#echo "${FGGREEN}*${NORMAL}     Bienvenido!!                   ${FGGREEN}*${NORMAL}"
#echo "${FGGREEN}*${NORMAL}    Este es el servidor             ${FGGREEN}*${NORMAL}"
#echo "${FGGREEN}*${NORMAL}       de ${FGRED}Matias-Barrios${NORMAL}            ${FGGREEN}*${NORMAL}"
#echo "${FGGREEN}*${NORMAL}  \"No te olvides de poner el        ${FGGREEN}*${NORMAL}"
#echo "${FGGREEN}*${NORMAL}      ${FGYELLOW}WHERE${NORMAL} en el ${FGYELLOW}DELETE FROM${NORMAL}\"      ${FGGREEN}*${NORMAL}"
#echo "${FGGREEN}*${NORMAL}                                    ${FGGREEN}*${NORMAL}"
#echo "${FGGREEN}*${NORMAL}  Hoy es   ${FGCYAN}$( date +%D  )${NORMAL}                 ${FGGREEN}*${NORMAL}"
#echo "${FGGREEN}*${NORMAL}                                    ${FGGREEN}*${NORMAL}"
#echo "${FGGREEN}*${NORMAL}                                    ${FGGREEN}*${NORMAL}"
#echo "${FGGREEN}**************************************${NORMAL}"


# Prompt as in GitBash
export PS1="\[\e[31m\]\u\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[32m\]\W\[\e[m\] \$( GIT_BRANCH )\n $ "

export GOPATH='/home/matias/go'
export GOROOT='/usr/local/go'
export GOBIN='/home/matias/go/bin'

export PATH="$PATH:$GOBIN:$GOROOT"

source ~/.secrets

