# Magic Makefile Maker: a Modest Makefile Model (MMMMMM) 💫

## Introduction

Welcome to MMMMMM (Magic Makefile Maker), a tool designed to streamline the process of generating Makefiles for your C projects! With MMMMMM, you can create Makefiles quickly and effortlessly, freeing up your time to focus on more important tasks.

## Features

- **Efficiency**: Generate Makefiles in seconds with just a few simple commands.
- **Customization**: Tailor your Makefile to suit the specific needs of your project.
- **Ease of Use**: Intuitive commands make MMMMMM accessible to both beginners and experienced developers alike.

## Installation

To install MMMMMM on your system, simply run the following commands:

```bash
./Install.sh #You may need to give execution rights
```

## Usage

Once installed, you can use MMMMMM to generate a Makefile for your project by running the `makegen` command in your project directory. This will create a Makefile based on the structure of your project's source files.

## Example

Here's an example of the generated Makefile:

```makefile
NAME		=	BigInt

SRC_DIR		=	./sources
SRC			= $(shell find $(SRC_DIR) -name '*.c')

OBJ_DIR		=	./obj
OBJ			=	$(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRC))

CC			=	gcc

CFLAGS		=	-Wall -Wextra -Werror

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
	@$(CC) $(CFLAGS) -c -o $@ \$<

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
	@read MESSAGE; 	git commit -m "$$MESSAGE"

push:
	git push

fpush: commit push

work:
	@git pull
	@code .
	@make


.PHONY: all clean fclean re

```

## Contributing

We welcome contributions from the community! If you have any ideas for improving MMMMMM or would like to report a bug, please feel free to submit a pull request or open an issue on GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.