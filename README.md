# dotfiles

My own configure files for UNIX/Linux tools.

## Quick Start

1. Use the command `git clone https://github.com/Kaiser-Yang/dotfiles.git` to clone this repository.
2. Use the command `cd dotfiles` to enter the directory. Run `./dotfiles.sh -icef`.
    * `i`: Install all the dependencies.
    * `c`: Create symbolic links for configuration files.
    * `e`: Extract files. This will create symbolic links for each file instead of directories.
    * `f`: Install fonts.
    This is useful when you have other configuration files in the directories.
3. Run `nvim` to install plugins.

## More Information

You can use `./dotfiles.sh -h` to see more options.

When you run `./dotfiles.sh` with `-c`, it will create backup files for your original
configuration files with the suffix `.bak`. You can use `./dotfiles.sh -r` to restore your
original configuration files. If you create symbolic links with `/dot_files.sh -ce`,
you should use `./dotfiles.sh -re` to restore your original configuration files.

There is a file called `replace_md_image.py`, this file receive a directory as a parameter, and it
will download all the images in the markdown files (recursively) in the directory and replace the
image links with the local links. This will backup your markdown files first.

## Basic Shortcuts

Note that my leader key is `Space`.

Note that in the `Mode` column, `N` means normal mode, `I` means insert mode, `V` means visual mode,
`T` means terminal mode, `X` means select mode, and `N I` means normal mode and insert mode.

| Shortcut    | Mode      | Description |
| -           | -         | - |
| \<C-T>      | N I T     | Toggle a terminal |
| Q           | N         | Unload a buffer, close a window or tab |
| \<LEADER>r  | N         | Run the current file depends on its filetype |
| \<LEADER>ay | N         | Copy all lines of current buffer to plus register |

## Window

| Shortcut   | Mode | Description                                                    |
| -          | -    | -                                                              |
| \<LEADER>h | N    | Split window horizontally, and move cursor to the left window  |
| \<LEADER>l | N    | Split window horizontally, and move cursor to the right window |
| \<LEADER>j | N    | Split window vertically, and move cursor to the bottom window |
| \<LEADER>k | N    | Split window vertically, and move cursor to the top window |
| \<LEADER>tt | N    | Toggle expandtab |
| \<LEADER>t2 | N    | Set tabstop to 2 spaces |
| \<LEADER>t4 | N    | Set tabstop to 4 spaces |
| \<LEADER>t8 | N    | Set tabstop to 8 spaces |
| \<C-H>     | N  | Move the cursor to the left window |
| \<C-J>     | N  | Move the cursor to the bottom window  |
| \<C-K>     | N  | Move the cursor to the top window     |
| \<C-L>     | N  | Move the cursor to the right window   |
| \<LEADER>1 | N    | Go to the first buffer |
| \<LEADER>2 | N    | Go to the second buffer |
| ...        | ...  | ... |
| \<LEADER>8 | N    | Go to the eighth buffer |
| \<LEADER>9 | N    | Go to the ninth buffer |
| Up         | N    | Smart resize the current window to the top |
| Down       | N    | Smart resize the current window to the bottom |
| Left       | N    | Smart resize the current window to the left |
| Right      | N    | Smart resize the current window to the right |

## Copy and Paste

| Shortcut    | Mode | Description                                                                                      |
| -           | -    | -                                                                                                |
| Y           | N    | Copy till end of line to unnamed register                                                        |
| \<LEADER>y  | N V  | Copy to system clipboard, this is like `y`, for example, you can use `<leader>yw` to copy a word |
| yaf | N    | Copy all contents in the current buffer to system clipboard                                      |
| \<LEADER>Y  | N    | Copy till end of line to system clipboard                                                        |
| \<LEADER>p  | N    | Paste from system clipboard                                                                      |
| \<LEADER>P  | N    | Paste from system clipboard before cursor                                                        |

## Cursor Movement

| Shortcut | Mode | Description                                                                                                        |
| -        | -    | -                                                                                                                  |
| \<C-J>   |      | Move the cursor to the next selection     |
| \<C-K>   |      | Move the cursor to the previous selection |

## Markdown Helper

These settings only work in a markdown file.

Some of the settings below will insert `<++>` as a placeholder symbol, and you can use `,f` to move
the cursor out of the current block and remove the placeholder symbol.

| Shortcut | Mode | Description                                                                      |
| -        | -    | -                                                                                |
| ,f       | I    | Move the cursor out of the current block and remove next placeholder symbol      |
| ,t       | I    | Insert command line block and leave the cursor where you can input the command   |
| ,b       | I    | Insert bold line block and leave the cursor where you can input the bold content |
| ,m       | I    | Insert math line block and leave the cursor where you can input the math         |
| ,M       | I    | Insert math block and leave the cursor where you can input the math              |
| ,c       | I    | Insert code block, and leave the cursor where you should input the code language |
| ,n       | I    | Insert a new line symbol of html                                                 |

## Useful Plugins' Shortcuts

### Commenting

| Shortcut                   | Mode | Description                                        |
| -                          | -    | -                                                  |
| [count]\<space>c\<space> | N    | Toggle comments (line style)                       |
| [count]\<space>cs         | N    | Toggle comments (block style)                      |
| \<space>c[count][motion]  | N    | Toggle comments (line style) with motion           |
| gb[count][motion]  | N    | Toggle comments (block style) with motion          |
| \<space>c\<space>        | V    | Toggle comments (line style) of the selected line  |
| \<space>cs                | V    | Toggle comments (block style) of the selected line |

### Surrounding

| Shortcut              | Mode | Description                                          |
| -                     | -    | -                                                    |
| ys\<motion>\<bracket> | N    | Surround something                                   |
| yss\<bracket>         | N    | Surround the whole line with the character you input |
| ySS\<bracket>         | N    | Surround the whole line with the character you input |
| ds\<bracket>          | N    | Delete the surrounding you input                     |
| cs\<old>\<new>        | N    | Change the surround with a new one                   |
| S\<bracket>           | V    | Surround the selected characters                     |
| ys{motion}f{name} | N    | Surround the part with a function call                                                                       |
| dsf               | N    | Delete a function call, only parameters will be left                                                         |
| csf{name}         | N    | Change a function call with a new one                                                                        |

Some examples of surrounding:

* `ysf;{`: surround the character from the cursor to next `;` with `{}`.
* `yst;{`: surround the character from the cursor till next `;` with `{}`, this will leave the `;`
out of the surrounding.
* `ds(`: delete the `()` surrounding current part.
* `cs([`: change the `()` with `[]` for current surrounded part.

NOTE: the difference between `ysw[` ans `ysw]` is that the former will add white space at left and
right, the latter will not.

### Code Related
<!--| gh         | N    | Go to the header file |-->
<!--| H          | N    | Quick fix |-->
| Shortcut   | Mode | Description                                                           |
| -          | -    | -                                                                     |
| gd         | N    | Go to definition                                                      |
| gr         | N    | Go to references                                                      |
| \<LEADER>R | N    | Rename the current symbol                                             |
| ]d         | N    | Go to next diagnostic                                                 |
| [d         | N    | Go to previous diagnostic                                             |
| K | N    | Show document symbols, this can also be used to show variables' types |

### Git Related

| Shortcut | Mode | Description                                              |
| -        | -    | -                                                        |
| ]g       | N    | Go to next git hunk                                      |
| [g       | N    | Go to previous git hunk                                  |
| ]x       | N    | Go to next git conflict                                  |
| [x       | N    | Go to previous git conflict                              |
| gcu      | N    | Undo (reset) current git hunk                            |
| gcd      | N    | Show difference of current git hunk                      |
| gcc      | N    | When there is a conflict, this will keep current change  |
| gci      | N    | When there is a conflict, this will keep incoming change |
| gcb      | N    | When there is a conflict, this will keep both changes    |
| gcn      | N    | When there is a conflict, this will keep none change     |

### Automatic Completion

| Shortcut | Mode | Description                                                            |
| -        | -    | -                                                                      |
| C-F      | I    | Select one line when `copilot` suggestions are shown                   |
| A-F      | I    | Select one word when `copilot` suggestions are shown                   |
| A-Enter  | I    | Select all when `copilot` suggestions are shown                        |
| \<ENTER> | I    | Confirm the completion item of blink.cmp |

### Others
<!--| \<C-Q>     | N I  | Open undo history |-->
<!--| \<LEADER>a | N    | Align a block, `:`, `=` and `\|` are supported, for example, you can use `<LEADER>a=` to align a block of assignments |-->
| Shortcut          | Mode | Description                                                                                                  |
| -                 | -    | -                                                                                                            |
| \<C-W>            | N   | Toggle code outline                                                                                          |
| \<C-E>            | N   | Toggle explorer                                                                                              |
| \<C-P>            | N   | Find files in the current directory or a git root directory                                                  |
| \<C-F>            | N   | Find contents in the current directory or a git root directory                                               |
| \<CR>             | N    | In file explorer, this will enter a directory or open a file                                                 |
| \<BS>             | N    | In file explorer, this will go to the `..` directory. You can use `?` to see more mappings in file explorer. |
| gy                | N    | List all the yanked contents                                                                                 |
| H                 | N    | Go to the left buffer shown in `bufline`                                                                     |
| L                 | N    | Go to the right buffer shown in `bufline`                                                                    |
| \<C-D>            | I    | Scroll down the completion preview window, if there is one                                                   |
| \<C-U>            | I    | Scroll up the completion preview window, if there is one                                                     |

### Debugger

| Shortcut   | Mode | Description                             |
| -          | -    | -                                       |
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
