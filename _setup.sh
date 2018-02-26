#!/usr/bin/env bash

if [[ -f ../_setup.sh  ]]; then
    source ../_setup.sh
else

    if [ -z "$build_path" ];
        build_path="$HOME/tmp/buld"
        mkdir -p $build_path
    fi

    if  [  ! declare -F git_clone_or_checkout  ]; then
      pushd $build_path
      wget -nv -N https://raw.githubusercontent.com/thomaswhite/ubuntu-bash-files/master/.bash_functions_git
      source .bash_functions_git
      popd
    fi
fi


