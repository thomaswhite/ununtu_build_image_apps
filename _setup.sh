#!/usr/bin/env bash

if [[ -f ../_setup.sh  ]]; then
    source ../_setup.sh
else

    if [ ! -f build_env_setup.bash ]; then
       wget -N -q https://raw.githubusercontent.com/thomaswhite/ubuntu-bash-files/master/bin/build_env_setup.bash
    fi

    source build_env_setup.bash
fi


