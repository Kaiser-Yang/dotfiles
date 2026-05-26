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
original configuration files. If you create symbolic links with `/dot_files.sh -ce`,
you should use `./dotfiles.sh -re` to restore your original configuration files.

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

## Copy and Paste

| Shortcut   | Mode | Description                                                                                      |
| ---------- | ---- | ------------------------------------------------------------------------------------------------ |
| Y          | N    | Copy till end of line to unnamed register                                                        |
| \<LEADER>y | N V  | Copy to system clipboard, this is like `y`, for example, you can use `<leader>yw` to copy a word |
| yaf        | N    | Copy all contents in the current buffer to system clipboard                                      |
| \<LEADER>Y | N    | Copy till end of line to system clipboard                                                        |
| \<LEADER>p | N    | Paste from system clipboard                                                                      |
| \<LEADER>P | N    | Paste from system clipboard before cursor                                                        |

## Cursor Movement

| Shortcut | Mode | Description                               |
| -------- | ---- | ----------------------------------------- |
| \<C-J>   |      | Move the cursor to the next selection     |
| \<C-K>   |      | Move the cursor to the previous selection |

## Useful Plugins' Shortcuts

### Commenting

| Shortcut                 | Mode | Description                                        |
| ------------------------ | ---- | -------------------------------------------------- |
| [count]\<space>c\<space> | N    | Toggle comments (line style)                       |
| [count]\<space>cs        | N    | Toggle comments (block style)                      |
| \<space>c[count][motion] | N    | Toggle comments (line style) with motion           |
| gb[count][motion]        | N    | Toggle comments (block style) with motion          |
| \<space>c\<space>        | V    | Toggle comments (line style) of the selected line  |
| \<space>cs               | V    | Toggle comments (block style) of the selected line |

### Code Related

<!--| gh         | N    | Go to the header file |-->
<!--| H          | N    | Quick fix |-->

| Shortcut   | Mode | Description                                                           |
| ---------- | ---- | --------------------------------------------------------------------- |
| gd         | N    | Go to definition                                                      |
| gr         | N    | Go to references                                                      |
| \<LEADER>R | N    | Rename the current symbol                                             |
| ]d         | N    | Go to next diagnostic                                                 |
| [d         | N    | Go to previous diagnostic                                             |
| K          | N    | Show document symbols, this can also be used to show variables' types |

### Automatic Completion

| Shortcut | Mode | Description                                          |
| -------- | ---- | ---------------------------------------------------- |
| C-F      | I    | Select one line when `copilot` suggestions are shown |
| A-F      | I    | Select one word when `copilot` suggestions are shown |
| A-Enter  | I    | Select all when `copilot` suggestions are shown      |
| \<ENTER> | I    | Confirm the completion item of blink.cmp             |

### Others

<!--| \<C-Q>     | N I  | Open undo history |-->
<!--| \<LEADER>a | N    | Align a block, `:`, `=` and `\|` are supported, for example, you can use `<LEADER>a=` to align a block of assignments |-->

| Shortcut | Mode | Description                                                                                                  |
| -------- | ---- | ------------------------------------------------------------------------------------------------------------ |
| \<C-W>   | N    | Toggle code outline                                                                                          |
| \<C-E>   | N    | Toggle explorer                                                                                              |
| \<C-P>   | N    | Find files in the current directory or a git root directory                                                  |
| \<C-F>   | N    | Find contents in the current directory or a git root directory                                               |
| \<CR>    | N    | In file explorer, this will enter a directory or open a file                                                 |
| \<BS>    | N    | In file explorer, this will go to the `..` directory. You can use `?` to see more mappings in file explorer. |
| gy       | N    | List all the yanked contents                                                                                 |
| H        | N    | Go to the left buffer shown in `bufline`                                                                     |
| L        | N    | Go to the right buffer shown in `bufline`                                                                    |
| \<C-D>   | I    | Scroll down the completion preview window, if there is one                                                   |
| \<C-U>   | I    | Scroll up the completion preview window, if there is one                                                     |

### Debugger

| Shortcut   | Mode | Description                             |
| ---------- | ---- | --------------------------------------- |
| \<LEADER>D | N    | Toggle the `dap-ui`.                    |
| \<LEADER>b | N    | Toggle the break point at current line. |
| \<F4>      | N    | Terminate current process.              |
| \<F5>      | N    | Continue.                               |
| \<F6>      | N    | Restart current process.                |
| \<F9>      | N    | Back.                                   |
| \<F10>     | N    | Next (step over).                       |
| \<F11>     | N    | Step in.                                |
| \<F12>     | N    | Finish (step out).                      |

# Contribution

If you have any suggestion or find any bug, please feel free to open an issue or pull request.
