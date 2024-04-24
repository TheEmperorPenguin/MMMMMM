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
- `-l`: Install locally in your home directory.
- `-n <customExecName>`: Specify a custom name for the command after installation.
- `-p <pathToInstall>`: Modify the installation path (default is `/usr/bin`).

For example:
```bash
./Install.sh -l # Install locally in your home directory
./Install.sh -n "makegenerator" # Specify a custom name for the command
./Install.sh -p "~/" # Install to your home
```

## MMMMMM Usage

Once installed, you can use MMMMMM to generate a Makefile for your project by running the `MMMMMM` command in your project directory. This will create a Makefile based on the structure of your project's source files.

MMMmmm also supports the `-m` flag, which moves every `.c` file to `./src` and every `.h` file to `./includes`. For example:

```bash
MMMMMM -m
```

This will move all `.c` files to `./src` and all `.h` files to `./includes` directories.

## Contributing

We welcome contributions from the community! If you have any ideas for improving MMMMMM or would like to report a bug, please feel free to submit a pull request or open an issue on GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
