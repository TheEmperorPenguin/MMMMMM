#!/bin/bash

current_directory=$(basename "$PWD")
toilet -f future --filter gay:border:crop $current_directory > CustomHeader.hd
echo "NAME		=	$current_directory

SRC_DIR		=	./sources
SRC         = \$(shell find \$(SRC_DIR) -name '*.c')

OBJ_DIR		=	./obj
OBJ			=	\$(patsubst \$(SRC_DIR)/%.c,\$(OBJ_DIR)/%.o,\$(SRC))

CC			=	gcc

CFLAGS		=	-Wall -Wextra -Werror

all: \$(OBJ_DIR) \$(NAME)
	clear
	@make header --no-print-directory
header:
	@cat CustomHeader.hd

\$(OBJ_DIR):
	@if [ ! -d \"\$(OBJ_DIR)\" ]; then mkdir \$(OBJ_DIR); fi

\$(NAME): \$(OBJ)
	@\$(CC) -o \$(NAME) \$(OBJ) \$(CFLAGS)

\$(OBJ_DIR)/%.o: \$(SRC_DIR)/%.c
	@\$(CC) \$(CFLAGS) -c -o \$@ \\$<

clean:
	@rm -rf \$(OBJ_DIR)

fclean: clean
	@rm -f \$(NAME)

re: fclean all

run: all
	@./\$(NAME)

commit:
	@make fclean --no-print-directory
	@git add *
	@printf \"Commit message: \"
	@read MESSAGE; \
	git commit -m \"\$\$MESSAGE\"

push:
	git push

fpush: commit push

work:
	@git pull
	@code .
	@make


.PHONY: all clean fclean re" > Makefile