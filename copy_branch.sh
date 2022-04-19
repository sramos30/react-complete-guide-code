#!/usr/bin/env bash

usage() {
    #if [ "$*" ]; then
    #    echo "$*"
    #    echo
    #fi
    echo "Usage: "$(basename $0)" branch-name"
    echo "                             "
    exit 2
}

copy_brnach() {
    if [ -n "$1" ]
    then
        echo "Branch: $1";

        cd ./react-complete-guide-code
        git switch --discard-changes "${BRANCH_NAME}"
        mkdir -p "../${BRANCH_NAME}/"
        rsync -hvar --delete --force --exclude=.git ./ "../${BRANCH_NAME}/"
        cp .gitignore "../${BRANCH_NAME}/"
        cd ..
        ls -lias "./${BRANCH_NAME}"
    fi
}

if [ -z $1 ]
then
    usage
else
    for BRANCH_NAME in $*
    do
      copy_brnach "$BRANCH_NAME"
    done
fi
