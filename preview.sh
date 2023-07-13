#!/bin/bash
set -e



# Action to perform
ACTION=$1
PREV_REPO_URL=""

function usage() {
    echo "Usage: preview.sh <action>"
    echo "Actions:"
    echo "  init - initialize preview"
    echo "  start - start preview"
    exit 1
}

init(){
    # check if .prev file exists in folder
    if [ -f ".prev" ]; then
        echo "Preview already initialized"
        get_url
        exit 1
    else
        set_url
    fi
}

# get PREV_REPO_URL from .prev file
get_url() {
    #get REPO_URL from .prev file
    PREV_REPO_URL=$(cat .prev | grep 'PREV_REPO_URL' | cut -d '=' -f2)
    echo "REPO_URL is $PREV_REPO_URL"
}

#set PREV_REPO_URL in .prev file
set_url() {
    #set REPO_URL in .prev file
    read -p "Enter repo url: " PREV_REPO_URL
    echo "PREV_REPO_URL=$PREV_REPO_URL" > .prev
}

#clone PREV_REPO_URL
clone_repo() {
    echo "Cloning repo"
    git clone $PREV_REPO_URL repo
}


#start for npm projects
start_npm() {
    echo "Starting npm project"
    npm install
    COMMAND="npm start"

    #check if next.config.js exists
    if [ -f "next.config.js" ]; then
        COMMAND="npm run dev"
    fi

    #execute command
    $COMMAND

}

check_pjson_exists() {
    # find . -name "package.json" -type f -print0 | xargs -0 grep -l "name"
    FOLDER_NAME=$(find . -name "package.json" -type f -print0 | xargs -0 grep -l "name" | sed 's/\/package.json//g')
    echo $FOLDER_NAME
    #return folder name whe
}

move_to_js_repo() {
    cd $(check_pjson_exists)
}

start(){
    get_url
    #check if repo url is set
    if [ -z "$PREV_REPO_URL" ]; then
        echo "Repo url not set"
        usage
        exit 1
    fi
    #check if repo folder exists
    if [ ! -d "repo" ]; then
        clone_repo
    fi
    cd repo
    move_to_js_repo

    #check if package.json exists
    if [ ! -f "package.json" ]; then
        echo "Not npm things"
        exit 1
    fi

    start_npm
}


if [ -z "$ACTION" ]; then
    usage
    exit 1
fi
#if init then prompt for repo url
if [ "$ACTION" == "init" ]; then
    init
    start
    exit 1
elif [ "$ACTION" == "start" ]; then
    start
else
    echo "Invalid action"
    usage
    exit 1
fi
