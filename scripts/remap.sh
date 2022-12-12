#!/usr/bin/env bash

(
set -e
PS1="$"
basedir="$(cd "$1" && pwd -P)"
workdir="$basedir/base"
minecraftversion="$(cat "${workdir}/Paper/BuildData/info.json" | grep minecraftVersion | cut -d '"' -f 4)"
minecraftserverurl="https://launcher.mojang.com/v1/objects/5fafba3f58c40dc51b5c3ca72a98f62dfdae1db7/server.jar"
minecrafthash=$(cat "${workdir}/Paper/BuildData/info.json" | grep minecraftHash | cut -d '"' -f 4)
accesstransforms="$workdir/Paper/BuildData/mappings/"$(cat "${workdir}/Paper/BuildData/info.json" | grep accessTransforms | cut -d '"' -f 4)
classmappings="$workdir/Paper/BuildData/mappings/"$(cat "${workdir}/Paper/BuildData/info.json" | grep classMappings | cut -d '"' -f 4)
membermappings="$workdir/Paper/BuildData/mappings/"$(cat "${workdir}/Paper/BuildData/info.json" | grep memberMappings | cut -d '"' -f 4)
packagemappings="$workdir/Paper/BuildData/mappings/"$(cat "${workdir}/Paper/BuildData/info.json" | grep packageMappings | cut -d '"' -f 4)
decompiledir="$workdir/mc-dev"
jarpath="$decompiledir/$minecraftversion"
mkdir -p "$decompiledir"

if [ ! -f  "$jarpath.jar" ]; then
    echo "Downloading unmapped vanilla jar..."
    curl -s -o "$jarpath.jar" "$minecraftserverurl"
    if [ "$?" != "0" ]; then
        echo "Failed to download the vanilla server jar. Check connectivity or try again later."
        exit 1
    fi
fi

# OS X & FreeBSD don't have md5sum, just md5 -r
command -v md5sum >/dev/null 2>&1 || {
    command -v md5 >/dev/null 2>&1 && {
        shopt -s expand_aliases
        alias md5sum='md5 -r'
        echo "md5sum command not found, using an alias instead"
    } || {
        echo >&2 "No md5sum or md5 command found"
        exit 1
    }
}

checksum=$(md5sum "$jarpath.jar" | cut -d ' ' -f 1)
if [ "$checksum" != "$minecrafthash" ]; then
    echo "The MD5 checksum of the downloaded server jar does not match the BuildData hash."
    exit 1
fi

# These specialsource commands are from https://hub.spigotmc.org/stash/projects/SPIGOT/repos/builddata/browse/info.json
if [ ! -f "$jarpath-cl.jar" ]; then
    echo "Applying class mappings..."
    java -jar "$basedir/bin/SpecialSource-2.jar" map -i "$jarpath.jar" -m "$classmappings" -o "$jarpath-cl.jar" 1>/dev/null
    if [ "$?" != "0" ]; then
        echo "Failed to apply class mappings."
        exit 1
    fi
fi

if [ ! -f "$jarpath-m.jar" ]; then
    echo "Applying member mappings..."
    java -jar "$basedir/bin/SpecialSource-2.jar" map -i "$jarpath-cl.jar" -m "$membermappings" -o "$jarpath-m.jar" 1>/dev/null
    if [ "$?" != "0" ]; then
        echo "Failed to apply member mappings."
        exit 1
    fi
fi

if [ ! -f "$jarpath-mapped.jar" ]; then
    echo "Creating remapped jar..."
    java -jar "$basedir/bin/SpecialSource.jar" --kill-lvt -i "$jarpath-m.jar" --access-transformer "$accesstransforms" -m "$packagemappings" -o "$jarpath-mapped.jar" 1>/dev/null
    if [ "$?" != "0" ]; then
        echo "Failed to create remapped jar."
        exit 1
    fi
fi
)
