#!/bin/bash
moveScript=true
header=true
extraFlags=""
SRCDIR="./src"
compiler="gcc"	#should be "" when there will be default compiler by language
current_directory=$(basename "$PWD")
headerText="$current_directory"

usage() {
    echo "Usage: $0 [-n, --NoMove] [-f|--Flags <flags>] ([--NoHeader] > [[-h|--Header <header text>]])  [-c|--Compiler] [-l <installDir>] [-cpp]"
    echo "Options:"
    echo "  -n, --NoMove: Doesnt touch the project file structure"
    echo "  -f, --Flags <flags>: Additional flags for compilation"
    echo "  --NoHeader: Skip header creation"
	echo "  -h, --Header <header text>: specify the text printed to standard output when doing a make"
    echo "  -c, --Compiler: specify the compiler for the Makefile"
    echo "  -l <installDir>: Specify installation directory"
    echo "  -cpp: Output 'cpp' and exit"
	if [ -f "./Makefile" ]; then
		exit 1
	else
		mv .old_Makefile Makefile
		exit 2
	fi
}

if [ -f "./Makefile" ]; then #check right at the start before doing anything to avoid uncessary code execution
    read -rp "Do you want to continue? (y/n): " choice
    case "$choice" in
      y|Y )
        echo "User chose to continue."
		mv Makefile .old_Makefile
        ;;
      n|N )
        echo "Aborting MMMMMM"
		exit 1
        ;;
      * )
        echo "Invalid response. Please enter 'y' or 'n'."
		exit 2
        ;;
    esac
fi

count_and_compare_files() #auto detect the language (c, cpp)
{
    local dir=${1:-.}
    
    cpp_count=$(find "$dir" -type f -name '*.cpp' | wc -l)
    hpp_count=$(find "$dir" -type f -name '*.hpp' | wc -l)
    
    c_count=$(find "$dir" -type f -name '*.c' | wc -l)
    h_count=$(find "$dir" -type f -name '*.h' | wc -l)
    
    total_cpp_hpp=$((cpp_count + hpp_count))
    total_c_h=$((c_count + h_count))

    
    if [ "$total_cpp_hpp" -gt "$total_c_h" ]; then
        echo cpp #cpp is probably used
    else
		echo c #c is probably used
    fi
}
#count_and_compare_files


while [ $# -gt 0 ]; do #Get all the options in input
	case $1 in
		-n | --NoMove )
			moveScript=false
			SRCDIR="./"
		;;
		-f | --Flags )	
            shift
            if [ -z "$1" ]; then
                echo "Error: Missing argument for $1"
                exit 1
            fi
            extraFlags="$1"
            ;;
		--NoHeader )
			header=false
			;;
		-h | --Header )
		    shift
            if [ -z "$1" ]; then
                echo "Error: Missing argument for $1"
                exit 1
            fi
            headerText="$1"
			;;
		-c | --Compiler )
            shift
            if [ -z "$1" ]; then
                echo "Error: Missing argument for $1"
                exit 1
            fi
            compiler="$1"
            ;;
		-l )
            shift
            if [ -z "$1" ]; then usage; fi
            installDir="$1"
            ;;
		-cpp )
			echo "cpp"
			exit 0
		;;
        -* )
            usage
            ;;
        * )
            usage
            ;;
	esac
	shift
done
shift $((OPTIND -1))


createHeader()	#custom header creation
{
	if [ -x "$(command -v toilet)" ]; then
		toilet -f future --filter gay:border:crop $headerText > CustomHeader.hd
	else
		echo "$current_directory" > CustomHeader.hd
	fi
}

if [ "$header" = true ]; then
	createHeader
fi


move_files() #Move to destDir all file with pattern from srcDir
{
	local destDir=$1
	local pattern=$2
	local srcDir=${3:-./}

    mkdir -p "$destDir"

	while read -r file; do
		# Get the directory structure of the file relative to the source directory
		relDir="${file%/*}"
		relDir="${relDir#./}"
		# Create the corresponding directory structure in the destination directory
		mkdir -p "$destDir/$relDir"
		# Move the file to the destination directory while preserving the directory structure
		mv "$file" "$destDir/$relDir"
	done < <(find "$srcDir" -type f -name "$pattern")
}


delete_empty_dirs_in_current() {
    local current_dir="./"

    # Recursively find and delete empty directories
    find "$current_dir" -type d -empty -delete
}


if [ "$moveScript" = true ]; then
	move_files "./src" "*.c"
	move_files "./includes" "*.h"
	delete_empty_dirs_in_current

    destDir="./includes"
fi

# variables expanded need to be exported
export current_directory
export extraFlags
export compiler
export SRCDIR
# envsubst NEED single quote
# shellcheck disable=SC2016
envsubst '$current_directory $extraFlags $compiler $SRCDIR' <<"EOMAKEFILE" > Makefile
NAME		=	${current_directory}

SRC_DIR		=	${SRCDIR}
SRC         = $(shell find $(SRC_DIR) -name '*.c')

OBJ_DIR		=	./obj
OBJ			=	$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC))

CC			=	${compiler}

INCLUDE_DIR =   ./includes

CFLAGS		=	-Wall -Wextra -Werror -I$(INCLUDE_DIR) ${extraFlags}

all: $(OBJ_DIR) $(NAME)
	clear
	@make header --no-print-directory
header:
	@cat CustomHeader.hd

$(OBJ_DIR):
	@if [ ! -d "$(OBJ_DIR)" ]; then mkdir $(OBJ_DIR); fi

$(NAME): $(OBJ)
	@$(CC) -o $(NAME) $(OBJ) $(CFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@$(CC) $(CFLAGS) -c -o $@ $<

clean:
	@rm -rf $(OBJ_DIR)

fclean: clean
	@rm -f $(NAME)

re: fclean all

run: all
	@./$(NAME)

commit:
	@make fclean --no-print-directory
	@git add *
	@printf "Commit message: "
	@read MESSAGE; \
	git commit -m "$$MESSAGE"

push:
	git push

fpush: commit push

work:
	@git pull
	@code .
	@make


.PHONY: all header clean fclean re run commit push fpush work
EOMAKEFILE

# un-export variable without losing value
export -n current_directory
export -n extraFlags
export -n compiler
export -n SRCDIR
