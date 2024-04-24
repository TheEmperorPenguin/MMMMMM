#!/bin/bash

customName=MMMMMM
installDir=/usr/bin/

while getopts ":n:p:" opt; do
  case ${opt} in
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
cp MMMMMM.sh $installDir$customName

echo "Installation complete."