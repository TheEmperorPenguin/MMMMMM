#!/bin/bash

customName=MMMMMM
installDir=/usr/bin/
homeInstall=false
moveScript=false
pathInstall=false

usage() {
    echo "Usage: $0 [-h] [-n <customName>] [-l <installDir>] [-p | --Path]"
    exit 1
}

# Parse options
while [ $# -gt 0 ]; do
    case "$1" in
        -h )
            homeInstall=true
            ;;
        -n )
            shift
            if [ -z "$1" ]; then usage; fi
            customName="$1"
            ;;
        -l )
            shift
            if [ -z "$1" ]; then usage; fi
            installDir="$1"
            ;;
        -p | --Path )
            pathInstall=true
            ;;
        -* )
            usage
            ;;
        * )
            break
            ;;
    esac
    shift
done

chmod 777 ./MMMMMM.sh
if [ "$homeInstall" = true ]; then
    cp MMMMMM.sh ~/.cmds/$customName
elif [ "$installDir" = "/usr/bin/" ]; then
    sudo cp MMMMMM.sh "$installDir$customName"
else
    cp MMMMMM.sh "$installDir$customName"
fi

if [ "$pathInstall" = true ]; then
    echo 'export PATH="$HOME/.cmds/:$PATH"' >> ~/.zshrc
fi

echo "Installation complete."