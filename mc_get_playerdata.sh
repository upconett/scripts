#!/bin/bash

dir="/home/minecraft/spigot-1.20.2/world/playerdata"

if [ ! $1 ]
then
    echo
    echo "Usage: mc_get_playerdata.sh <username>"
    echo
    exit 1
fi

uuidnick $1 .dat | xargs -I {} nbt --input=$dir/{}
