#!/usr/bin/env bash

# no arguments, then install all
if [ "$#" == "0" ]; then
	echo "please provide your github token"
    exit
fi

function create_if_not_exists() {
    [[ ! -d $1 ]] && mkdir $1
}

create_if_not_exists ~/workspace

cd ~/workspace
git clone git@github.com:jepsen-io/jepsen.git
git clone git@github.com:gentics/mesh.git

create_if_not_exists dovidio
cd dovidio
curl "https://api.github.com/users/dovidio/repos?access_token=$1" | grep -w clone_url