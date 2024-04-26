#!/bin/bash
moveScript=false
current_directory=$(basename "$PWD")

createHeader()
{
	if [ -x "$(command -v toilet)" ]; then
		toilet -f future --filter gay:border:crop "$current_directory" > CustomHeader.hd
	else
		echo "$current_directory" > CustomHeader.hd
	fi
}
createHeader

while [ $# -gt 0 ]; do
	case $1 in
		-m )
			moveScript=true
		;;
		-c )
			echo "c"
			exit 0
		;;
		-cpp )
			echo "cpp"
			exit 0
		;;
		\? )
			echo "Invalid option: -$OPTARG" 1>&2
			exit 1
		;;
	esac
	shift
done
shift $((OPTIND -1))

move_files()
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

if [ "$moveScript" = true ]; then
	move_files "./src" "*.c"
	move_files "./includes" "*.h"

    destDir="./includes"
fi

if [ -f "./Makefile" ]; then
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

# variables expanded need to be exported
export current_directory
# envsubst NEED single quote
# shellcheck disable=SC2016
envsubst '$current_directory' <<"EOMAKEFILE" > Makefile
NAME		=	${current_directory}

SRC_DIR		=	./src
SRC         = $(shell find $(SRC_DIR) -name '*.c')

OBJ_DIR		=	./obj
OBJ			=	$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC))

CC			=	gcc

INCLUDE_DIR =   ./includes

CFLAGS		=	-Wall -Wextra -Werror -I$(INCLUDE_DIR)

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
