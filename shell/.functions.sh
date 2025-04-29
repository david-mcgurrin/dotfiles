# Create a day branch and markdown file
create_day() {
  if [ -z "$1" ]; then
    echo "Usage: create_day <day_number>"
    return 1
  fi

  local DAY_NUMBER=$1
  local REPO="https://github.com/david-mcgurrin/100-days-of-code"
  local WEEK_NUMBER=$(( ($DAY_NUMBER - 1) / 7 + 1 ))
  local BRANCH_NAME="day-$DAY_NUMBER"
  local FOLDER="Week $WEEK_NUMBER"
  local FILE_NAME="day-$DAY_NUMBER.md"
  local DATE=$(date +"%d/%m/%Y")

  git checkout -b $BRANCH_NAME
  mkdir -p "$FOLDER"

  cat <<EOT >> "$FOLDER/$FILE_NAME"
## Day $DAY_NUMBER

<i>$DATE</i>

- 
- 
EOT

  git add "$FOLDER/$FILE_NAME"
  git commit -m "Day $DAY_NUMBER"
  git push --set-upstream $REPO $BRANCH_NAME

  echo "Created branch $BRANCH_NAME, file $FOLDER/$FILE_NAME, and pushed to $REPO."
}

# Create a week branch and markdown file
create_week() {
  if [ -z "$1" ]; then
    echo "Usage: create_week <week_number>"
    return 1
  fi

  local WEEK_NUMBER=$1
  local REPO="https://github.com/david-mcgurrin/100-days-of-code"
  local BRANCH_NAME="week-$WEEK_NUMBER"
  local FOLDER="Week $WEEK_NUMBER"
  local FILE_NAME="week-$WEEK_NUMBER.md"
  local DATE=$(date +"%d/%m/%Y")

  git checkout -b $BRANCH_NAME
  mkdir -p "$FOLDER"

  cat <<EOT >> "$FOLDER/$FILE_NAME"
## Week $WEEK_NUMBER

### Plans

- 
- 

### Review

- 
- 
EOT

  git add "$FOLDER/$FILE_NAME"
  git commit -m "Week $WEEK_NUMBER"
  git push --set-upstream $REPO $BRANCH_NAME

  echo "Created branch $BRANCH_NAME, file $FOLDER/$FILE_NAME, and pushed to $REPO."
}

# Create new folder and CD into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Weather report
weather() {
  curl wttr.in/"$1"
}

# Return the branch name if we're in a git repo, or nothing otherwise.
git_check () {
  local gitBranch=$(git branch 2> /dev/null | sed -e "/^[^*]/d" -e "s/* \(.*\)/\1/")
  if [[ $gitBranch ]]; then
    echo -en $gitBranch
    return
  fi
}

# Return the status of the current git repo.
git_status () {
  local gitBranch="$(git_check)"
  if [[ $gitBranch ]]; then
    local statusCheck=$(git status 2> /dev/null)
    if [[ $statusCheck =~ 'Your branch is ahead' ]]; then
      echo -en 'ahead'
    elif [[ $statusCheck =~ 'Changes to be committed' ]]; then
      echo -en 'staged'
    elif [[ $statusCheck =~ 'no changes added' ]]; then
      echo -en 'modified'
    elif [[ $statusCheck =~ 'working tree clean' ]]; then
      echo -en 'clean'
    fi
  fi
}

# Print a dot indicating the current git status.
git_dot () {
  local gitCheck="$(git_check)"
  if [[ $gitCheck ]]; then
    local gitStatus="$(git_status)"
    local gitStatusDot='●'
    if [[ $gitStatus == 'staged' ]]; then
      local gitStatusDot='◍'
    elif [[ $gitStatus == 'modified' ]]; then
      local gitStatusDot='○'
    fi
    if [[ $gitCheck && ! $gitCheck == 'master' && $COLUMNS -lt 100 ]]; then
      echo -en "%F{#616161}⌥%f "
    fi
    echo -en "%F{"$(git_status_color)"}$gitStatusDot%f "
  fi
}

# Return a color based on the current git status.
git_status_color () {
  local gitStatus="$(git_status)"
  local statusText=''
  case $gitStatus in
    clean*)
      statusText="green"
      ;;
    modified*)
      statusText="magenta"
      ;;
    staged*)
      statusText="yellow"
      ;;
    ahead*)
      statusText="cyan"
      ;;
    *)
      statusText="white"
      ;;
  esac
  echo -en $statusText
}