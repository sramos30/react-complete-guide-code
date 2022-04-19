#!/usr/bin/env bash

usage() {
    #if [ "$*" ]; then
    #    echo "$*"
    #    echo
    #fi
    echo "Usage: "$(basename $0)"  switch|push branch-name"
    echo "                             "
    exit 2
}

switchBranch() {
    if [ -n "$1" ]
    then
        cd react-complete-guide-code
        git switch --discard-changes "${BRANCH_NAME}"
    fi
}

pushBranch() {
    if [ -n "$1" ]
    then
        cd react-complete-guide-code
        mkdir -p "../${BRANCH_NAME}/"
        rsync -hvar --delete --force --exclude=.git ./ "../${BRANCH_NAME}/"
        cp .gitignore "../${BRANCH_NAME}/"
        git add --all
        git commit -m "${BRANCH_NAME} changes"
        git push
        cd ..
    fi
}

if [ -n "react-complete-guide-code" ]
then
    git clone git@github.com:sramos30/react-complete-guide-code.git react-complete-guide-code
fi

if [ -z $2 ]
then
    usage
else
    if [ "$1" == "switch" ]
    then
        switchBranch "$BRANCH_NAME"
    else 
        if [ "$1" == "push" ]
        then
            pushBranch "$BRANCH_NAME"
        else
            usage
        fi 
    fi
fi
