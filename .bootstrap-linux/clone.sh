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

if [[ ! -d jepsen ]]; then 
    git clone git@github.com:jepsen-io/jepsen.git
fi

if [[ ! -d mesh ]]; then 
    git clone git@github.com:gentics/mesh.git
fi

create_if_not_exists ~/workspace/dovidio
cd ~/workspace/dovidio
curl -H "Authorization: $1" https://api.github.com/users/dovidio/repos | jq '.[] | select(.fork == false) | .clone_url' | xargs -n1 git clone