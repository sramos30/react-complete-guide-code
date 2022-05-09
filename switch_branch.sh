#!/usr/bin/env bash

usage() {
    #if [ "$*" ]; then
    #    echo "$*"
    #    echo
    #fi
    echo "Usage: "$(basename $0)" branch-name|push"
    echo "                                                "
    exit 2
}

switchBranch() {
    BRANCH_NAME="$1"
    echo "switchBranch ${BRANCH_NAME}"
    cd repository
    git branch ${BRANCH_NAME}
    git switch --discard-changes "${BRANCH_NAME}"
    echo ${BRANCH_NAME} > switched
}

pushBranch() {
    BRANCH_NAME="$1"
    echo "pushBranch ${BRANCH_NAME}"
    cd repository
    rm -f switched
    find . -type d -name node_modules -exec rm -rf {} \;
    mkdir -p "../${BRANCH_NAME}/"
    rsync -hvar --delete --force --exclude=.git ./ "../${BRANCH_NAME}/"
    cp .gitignore "../${BRANCH_NAME}/"
    git add --all
    git commit -m "${BRANCH_NAME} changes"
    git push --set-upstream origin ${BRANCH_NAME}
    cd ..
}

if [ ! -d "repository" ];
then
    git clone git@github.com:sramos30/react-complete-guide-code.git repository
fi

BRANCH_NAME=""
ACTION=""

if [ -z "$1" ];
then
    usage
fi

BRANCH_NAME=$(<./repository/switched ) 2> /dev/null

if [ "$1" == "push" ];
then
    ACTION=$1
else
    if [ "$1" != "${BRANCH_NAME}"] ];
    then
        BRANCH_NAME=$1
        ACTION="switch"
    fi
fi

if [ -z $BRANCH_NAME ];
then
    usage
fi

if [ "${ACTION}" == "switch" ];
then
    switchBranch "${BRANCH_NAME}"
else 
    if [ "${ACTION}" == "push" ];
    then
        pushBranch "${BRANCH_NAME}"
    else
        usage
    fi
fi
