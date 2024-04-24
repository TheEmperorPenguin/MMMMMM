#!/bin/bash

customName=MMMMMM
installDir=/usr/bin/
homeInstall=false
moveScript=false

while getopts ":n:p:l" opt; do
  case ${opt} in
    l )
      homeInstall=true
      ;;
    n )
      customName=${OPTARG}
      ;;
    p )
      installDir=${OPTARG}
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

chmod 777 ./MMMMMM.sh
if [ "$homeInstall" = true ]; then
    cp MMMMMM.sh ~/.cmds/$customName
elif [ "$installDir" = "/usr/bin/" ]; then
    sudo cp MMMMMM.sh "$installDir$customName"
else
    cp MMMMMM.sh "$installDir$customName"
fi

echo "Installation complete."