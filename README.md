# Magic Makefile Maker: a Modest Makefile Model (MMMMMM) 💫

Welcome to MMMMMM (Magic Makefile Maker), a tool designed to streamline the process of generating Makefiles for your C projects! With MMMMMM, you can create Makefiles quickly and effortlessly, freeing up your time to focus on more important tasks.

## Features

- **Efficiency**: Generate Makefiles in seconds with just a few simple commands.
- **Customization**: Tailor your Makefile to suit the specific needs of your project.
- **Ease of Use**: Intuitive commands make MMMMMM accessible to both beginners and experienced developers alike.

## Installation

To install MMMMMM on your system, simply run the following commands:

```bash
./Install.sh # You may need to give execution rights
```

The `install.sh` script supports the following flags:
- `-h`: Install locally in your home directory.
- `[-n | --Name] <customExecName>`: Specify a custom name for the command after installation.
- `-l <pathToInstall>`: Modify the installation path (default is `/usr/bin`).
- `[-p | --Path]`: Add command to $PATH (only works for zshrc).

For example:
```bash
./Install.sh -h # Install locally in your home directory
./Install.sh [-n | --Name] "makegenerator" # Specify a custom name for the command
./Install.sh -l "~/" # Install to your home
./Install.sh [-p | --Path] #Add to $PATH for easier usage (only works for zsh)
```

## MMMMMM Script Usage Guide

This guide provides detailed instructions on how to use the MMMMMM script for managing your project's Makefile and structure.

### Script Overview

The MMMMMM script is a powerful utility for automating various project management tasks, including the generation and modification of Makefiles, moving project files, and handling custom headers. The script supports C and C++ projects and offers several customizable options.

### Usage

```bash
Usage: ./MMMMMM.sh [-n, --NoMove] [-f|--Flags <flags>] ([--NoHeader] > [[-h|--Header <header text>]])  [-c|--Compiler] [-l <installDir>] [-cpp]
```

### Options

- `-n, --NoMove`: Does not modify the project file structure. By default, the script moves source and header files to `./src` and `./includes` respectively.
- `-f, --Flags <flags>`: Specifies additional flags for compilation.
- `--NoHeader`: Skips header creation.
- `-h, --Header <header text>`: Specifies custom text to be printed in the header when running `make`.
- `-c, --Compiler <compiler>`: Specifies the compiler to be used in the Makefile.
- `-l <installDir>`: Specifies the installation directory.
- `-cpp`: Outputs "cpp" and exits, indicating the script detected C++ files in the project.

### Example

```bash
./MMMMMM.sh -f "-O2 -g" -c gcc -h "My Project"
```

This example runs the script with the following options:
- Additional compiler flags: `-O2 -g`
- Compiler: `gcc`
- Custom header text: "My Project"

### Script Behavior

1. **Makefile Check**: If a `Makefile` is found in the current directory, the script prompts the user to continue or abort.
2. **Language Detection**: The script counts `.c` and `.cpp` files to detect whether the project is primarily in C or C++.
3. **Header Creation**: If header creation is enabled and `toilet` is installed, the script generates a stylized header. Otherwise, it uses the project directory name as the header.
4. **File Movement**: If `--NoMove` is not specified, the script moves `.c` and `.h` files to `./src` and `./includes` respectively and deletes empty directories.
5. **Makefile Generation**: The script generates a `Makefile` with environment variables expanded.

### Makefile Commands

The generated `Makefile` includes the following targets:

- `all`: Compiles the project and prints the custom header.
- `header`: Prints the custom header.
- `clean`: Removes object files.
- `fclean`: Removes object files and the compiled binary.
- `re`: Recompiles the project.
- `run`: Compiles and runs the project.
- `commit`: Cleans, adds all changes to git, and commits with a user-provided message.
- `push`: Pushes committed changes to the remote repository.
- `fpush`: Performs `commit` and `push` consecutively.
- `work`: Pulls the latest changes, opens the project in VS Code, and compiles the project. (might remove it later)

### Conclusion

The MMMMMM script is a versatile tool that simplifies project setup and maintenance, especially for C and C++ projects. By automating Makefile generation and file management, it helps streamline the development workflow.

## Contributing

I do welcome contributions! If you have any ideas or would like to report a bug, please feel free to submit a pull request or open an issue on GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
