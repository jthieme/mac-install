export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

export GITHUB_PAT=""

export CMIS_GRAPHQL_BASIC_AUTH=""

export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1]/p'
}
COLOR_DEF='%f'
COLOR_USR='%F{243}'
COLOR_DIR='%F{197}'
COLOR_GIT='%F{39}'
# About the prefixed `$`: https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_03.html#:~:text=Words%20in%20the%20form%20%22%24',by%20the%20ANSI%2DC%20standard.
NEWLINE=$'\n'
# Set zsh option for prompt substitution
setopt PROMPT_SUBST
export PROMPT='${COLOR_USR}%n ${COLOR_DIR}%d ${COLOR_GIT}$(parse_git_branch) ${COLOR_DEF}'

createNewBranch() {
    # if there are no params
    if [ $# -eq 0 ];
    then
      # display no params and exit
      echo "$0: Missing arguments"
      exit 1

    # if more than two params
    elif [ $# -gt 3 ];
    then
      # display too many params and exit
      echo "$0: Too many arguments: $@"
      exit 1

    else
      echo "We got some argument(s)"
      echo "==========================="
      echo "Number of arguments.: $#"
      echo "List of arguments...: $@"
      echo "Arg #1..............: $1"
      echo "Arg #2..............: $2"
      echo "Arg #3..............: $3"
      echo "==========================="
    fi

    # directory path
    dir=~/Documents/Projects/"$1"

    # check if repo param is in the projects directory
    if [ -d "$dir" ]; then
      echo "Directory $dir is valid"
      echo
    else
      echo "Directory $dir is not found"
      exit 1
    fi

    # add a space
    echo

    # change directory to repo that is passed
    cd ~/Documents/Projects/$1
    echo "Current directory is ~/Documents/Projects/$1"

    # check if user-permission option is being used
    if [ $3 = "up" ]; then
      echo "Checkout and pull UserPermissions"
      git checkout UserPermissions
      git pull
    else
      # change to PreRelease branch so we can branch off of that≈
      echo "Checkout and pull PreRelease"
      git checkout PreRelease
      git pull
    fi

    # add a space and add the branch then checkout from 2nd param
    echo
    echo "git checkout -b $2"
    git checkout -b $2

    # add a space and display the branch has been added
    echo
    echo "Branch $2 has been added and checked out"
    cd ~
}

alias newCard='createNewBranch'

git() {
  if [[ "$1" == "status" ]]
    then
      /usr/bin/git fetch
      /usr/bin/git status
    else
      /usr/bin/git $@ 
  fi
}

alias gfp='git fetch && git pull'

alias rebru='cd /usr/local/Caskroom && rm -rf bruno && cd ~ && brew install bruno'

alias awsl='aws --endpoint=http://localhost:4566 $@'

alias closeCodex='codex "/quit"'

alias jiraMoveTicketToCodeReview='codex "Use the Jira MCP server to move the ticket id that matches my branch excluding the dev/ to Code Review" && closeCodex'

alias create-pr='git push origin HEAD && gh pr create --base PreRelease --head $(git rev-parse --abbrev-ref HEAD) --title $(git rev-parse --abbrev-ref HEAD) --reviewer ICS-ENG/pth-web-team,ICS-ENG/pth-web-team-admins && jiraMoveTicketToCodeReview'

alias music-init='sudo ln -sf $HOME/.colima/default/docker.sock /var/run/docker.sock && aws sso login --profile music-non-prod'
alias music-start='colima start &&  npm run dev-aws'

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"