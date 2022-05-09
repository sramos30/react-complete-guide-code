#!/usr/bin/env bash

usage() {
    #if [ "$*" ]; then
    #    echo "$*"
    #    echo
    #fi
    echo "Usage: "$(basename $0)"  switch|push branch-name"
    echo "                                                "
    exit 2
}

switchBranch() {
    BRANCH_NAME="$1"
    echo "switchBranch ${BRANCH_NAME}"
    cd react-complete-guide-code
    git switch --discard-changes "${BRANCH_NAME}"
}

pushBranch() {
    BRANCH_NAME="$1"
    echo "pushBranch ${BRANCH_NAME}"
    cd react-complete-guide-code
    mkdir -p "../${BRANCH_NAME}/"
    rsync -hvar --delete --force --exclude=.git ./ "../${BRANCH_NAME}/"
    cp .gitignore "../${BRANCH_NAME}/"
    git add --all
    git commit -m "${BRANCH_NAME} changes"
    git push
    cd ..
}

if [ ! -d "react-complete-guide-code" ]
then
    git clone git@github.com:sramos30/react-complete-guide-code.git
fi

if [ -z $2 ]
then
    usage
else
    if [ "$1" == "switch" ]
    then
        switchBranch "$2"
    else 
        if [ "$1" == "push" ]
        then
            pushBranch "$2"
        else
            usage
        fi
    fi
fi
