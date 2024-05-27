#!/bin/bash

# Function to create random directories and files
create_files_and_dirs() {
    local language="$1"
    local num_dirs="$2"
    local num_files="$3"
    local file_extension
    local header_extension

    if [ "$language" == "c" ]; then
        file_extension=".c"
        header_extension=".h"
    elif [ "$language" == "cpp" ]; then
        file_extension=".cpp"
        header_extension=".hpp"
    else
        echo "Invalid language selection."
        exit 1
    fi

    mkdir -p testDir
    cd testDir || exit

    for (( i=1; i<=num_dirs; i++ )); do
        dir_name="dir_$i"
        mkdir -p "$dir_name"
    done

    for (( i=1; i<=num_files; i++ )); do
        file_name="file_$i"
        header_name="header_$i"

        dir_index=$(( ( RANDOM % num_dirs ) + 1 ))
        dir_name="dir_$dir_index"

        touch "$dir_name/$file_name$file_extension"
        touch "$dir_name/$header_name$header_extension"
    done

    echo "Created $num_dirs directories and $num_files pairs of $file_extension and $header_extension files."
}

# Prompt user for input
echo "Choose language (c/cpp):"
read -r language

echo "Enter number of directories to create:"
read -r num_dirs

echo "Enter number of .${language} and header files to create:"
read -r num_files

# Call the function with user inputs
create_files_and_dirs "$language" "$num_dirs" "$num_files"