# dotfiles

My own configure files for UNIX/Linux tools.

## Quick Start

1. Use the command `git clone https://github.com/Kaiser-Yang/dotfiles.git` to clone this repository.
2. Use the command `cd dotfiles` to enter the directory. Run `./dotfiles.sh -icsf`.
   - `i`: Install all the dependencies.
   - `c`: Create symbolic links for configuration files.
   - `s`: Change the login shell to `zsh`.
   - `f`: Install fonts.
3. Run `nvim` to install plugins.

**NOTE:** If you are using a `Mac` or you have problems telling you `unknow option: declare -A`,
this is because your `bash` version is too old. You can use `zsh dotfiles.sh -icsf`,
if you have `zsh` installed.

## More Information

You can use `./dotfiles.sh -h` to see more options.

When you run `./dotfiles.sh` with `-c`, it will create backup files for your original
configuration files with the suffix `.bak`. You can use `./dotfiles.sh -r` to restore your
original configuration files.

There is a file called `replace_md_image.py`, this file receive a directory as a parameter, and it
will download all the images in the markdown files (recursively) in the directory and replace the
image links with the local links. This will backup your markdown files first.

## Requirements

For markdown render working properly in `nvim`, you should install those tree-sitter parsers:

- `markdown`
- `markdown_inline`
- `html`
- `latex`
- `yaml`

And `pylatexenc` is required for rendering LaTeX formulas in markdown files. You can install it
with `pip install pylatexenc`.

## Useful Plugins' Shortcuts

### Automatic Completion

| Shortcut | Mode | Description                                          |
| -------- | ---- | ---------------------------------------------------- |
| C-F      | I    | Select one line when `copilot` suggestions are shown |
| A-F      | I    | Select one word when `copilot` suggestions are shown |
| A-Enter  | I    | Select all when `copilot` suggestions are shown      |

### Others

| Shortcut | Mode | Description                                                    |
| -------- | ---- | -------------------------------------------------------------- |
| \<C-P>   | N    | Find files in the current directory or a git root directory    |
| \<C-F>   | N    | Find contents in the current directory or a git root directory |
| \<CR>    | N    | In file explorer, this will enter a directory or open a file   |
| \<BS>    | N    | In file explorer, this will go to the `..` directory.          |
| gy       | N    | List all the yanked contents                                   |
| \<C-D>   | I    | Scroll down the completion preview window, if there is one     |
| \<C-U>   | I    | Scroll up the completion preview window, if there is one       |

### Debugger

| Shortcut | Mode | Description                |
| -------- | ---- | -------------------------- |
| \<F4>    | N    | Terminate current process. |
| \<F5>    | N    | Continue.                  |
| \<F6>    | N    | Restart current process.   |
| \<F9>    | N    | Back.                      |
| \<F10>   | N    | Next (step over).          |
| \<F11>   | N    | Step in.                   |
| \<F12>   | N    | Finish (step out).         |
