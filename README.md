# dotfiles
My own configure files for UNIX/Linux tools.

You can use `./dot_files.py update` to append contents to the `$HOME` directory automatically, and see the file for more details.

You can use `./dot_files.py recover` to copy the backed up files to `$HOME` directory automatically, and see the file for more details.

You can use `./dot_files.py`, which is same with `./dot_files.py recover && ./dot_files.py update`.

You can use `./dot_files.py init` for the first time install, which will install all plugins for vim and install fish and then set fith be your default shell, see the file for more details.

NOTE: if you want to use `./dot_files.py init`, be sure your conda is deactivated (there is no base or other conda name on your screen), and make sure you have `Python` order than `3.8` locally, because `ycm` can not be installed by this script within conda.

NOTE: There are `start_symbol_kaiserqzyue` and `end_symbol_kaiserqzyue` in every dot file. If you want to recover the dot files, you just need to delete contents from `start_symbol_kaiserqzyue` till `end_symbol_kaiserqzyue`. You can do this by `vim` easily: `gg/start_symbol_kaiserqzyue<Enter>d/end_symbol_kaiserqzyue<Enter>dd`. Besides, you can use `./dot_files.py recover` to recover, if your dot files have been updated after using `./dot_files.py update`.

# Vim Shortcuts
Note that my leader key is `Space`.

Note that in the `Mode` column, `N` means normal mode, `I` means insert mode, `V` means visual mode, and `N I` means normal mode and insert mode.

## Save and Quit
| Shortcut | Mode | Description       |
| -        | -    | -                 |
| Q        | N    | Quit but not save |
| \<C-S>   | N I  | Save but not quit |
| S        | N    | Save and quit     |

## Window
| Shortcut   | Mode | Description                                                    |
| -          | -    | -                                                              |
| \<C-H>     | N I  | Split window horizontally, and move cursor to the left window  |
| \<C-L>     | N I  | Split window horizontally, and move cursor to the right window |
| \<C-T>     | N I  | Create a new tab                                               |
| \<LEADER>h | N    | Move cursor to the next left window                            |
| \<LEADER>j | N    | Move cursor to the next down window                            |
| \<LEADER>k | N    | Move cursor to the next up window                              |
| \<LEADER>l | N    | Move cursor to the next right window                           |
| \<LEADER>H | N    | Close the current window, and reopen it at left                |
| \<LEADER>J | N    | Close the current window, and reopen it at bottom              |
| \<LEADER>K | N    | Close the current window, and reopen it at top                 |
| \<LEADER>L | N    | Close the current window, and reopen it at right               |
| \<LEADER>n | N    | Go to next tab                                                 |
| \<LEADER>b | N    | Go to previous tab                                             |
| \<LEADER>1 | N    | Go to the first tab                                            |
| \<LEADER>2 | N    | Go to the second tab                                           |
| ...        | ...  | ...                                                            |
| \<LEADER>8 | N    | Go to the eighth tab                                           |
| \<LEADER>9 | N    | Go to the ninth tab                                            |
| Up         | N I  | Resize +5 for the current window                               |
| Down       | N I  | Resize -5 for the current window                               |
| Left       | N I  | Resize -5 vertically for current window                        |
| Right      | N I  | Resize +5 vertically for current window                        |

## Copy and Paste
| Shortcut    | Mode | Description                                                                                      |
| -           | -    | -                                                                                                |
| Y           | N    | Copy till end of line to unnamed register                                                        |
| \<LEADER>y  | N V  | Copy to system clipboard, this is like `y`, for example, you can use `<leader>yw` to copy a word |
| \<LEADER>ya | N    | Copy all contents in the current buffer to system clipboard                                      |
| \<LEADER>Y  | N    | Copy till end of line to system clipboard                                                        |
| \<LEADER>p  | N I  | Paste from system clipboard                                                                      |
| \<LEADER>P  | N I  | Paste from system clipboard before cursor                                                        |

## Useful Plugins' Shortcuts
This part has a lot of shortcuts, and I'll only list some common ones. All the shortcuts started with `<LEADER>`, `[` or `]` can be seen in `vimwhichkey` plugin, which means you just need press `<LEADER>`, `[` or `]` and wait for a while, there will be pop up window to show all the shortcuts started with the key you press.

| Shortcut            | Mode | Description                                                                                                             |
| -                   | -    | -                                                                                                                       |
| \<C-Q>              | N I  | Open undo history                                                                                                       |
| \<C-W>              | N I  | Open outlook                                                                                                            |
| \<C-E>              | N I  | Open explorer                                                                                                           |
| \<C-P>              | N I  | Find files in the current directory or a git root directory                                                             |
| \<C-F>              | N I  | Find contents in the current directory or a git root directory                                                          |
| \<LEADER>c\<LEADER> | N    | Comment or uncomment the current line, this can be used as `2<LEADER>c<LEADER>` to comment or uncomment 2 lines         |
| \<LEADER>c\<LEADER> | V    | Comment or uncomment the selected line                                                                                  |
| \<LEADER>cl         | N    | Comment the current line and align left, this can be used as `2<LEADER>cl` to comment 2 lines |
| \<LEADER>cl         | V    | Comment the selected line and align left                                                                   |

## Code Related
| Shortcut   | Mode | Description                                                           |
| -          | -    | -                                                                     |
| gd         | N    | Go to definition                                                      |
| gr         | N    | Go to references                                                      |
| gh         | N    | Go to the header file                                                 |
| \<LEADER>R | N    | Rename the current symbol                                             |
| H          | N    | Quick fix                                                             |
| ]d         | N    | Go to next diagnostic                                                 |
| [d         | N    | Go to previous diagnostic                                             |
| \<LEADER>d | N    | Show document symbols, this can also be used to show variables' types |

## Automatic Completion
| Shortcut | Mode | Description                                                                                                 |
| -        | -    | -                                                                                                           |
| C-F      | I    | Select one line when `copilot` suggestions are shown                                                        |
| \<ESC>f  | I    | Select one word when `copilot` suggestions are shown. In 7-bit terminal press `<M-F>` will trigger `<ESC>f` |
| \<ENTER> | I    | Select current suggestion when one `coc` suggestion is selected                                             |
| \<ENTER> | I    | Select first suggestion when `coc` is not shown and `copilot` is shown                                      |
| \<C-C>   | I    | Cancel the completion, if `coc` and `copilot` are both shown, this will quit `coc`'s completion             |


## Cursor Movement
| Shortcut | Description                                                                                                        |
| -        | -                                                                                                                  |
| \<C-J>   | When there is a selection list and `j` will input letter j, `<C-J>` will move the cursor to the next selection     |
| \<C-K>   | When there is a selection list and `k` will input letter k, `<C-K>` will move the cursor to the previous selection |
| j        | When there is a selection list and you can not input with `j`, `j` will move the cursor to the next selection      |
| k        | When there is a selection list and you can not input with `k`, `k` will move the cursor to the previous selection  |

Note that when `coc` suggestion list is not shown but `copilot` is shown, it is possible to use `<C-J>` and `<C-K>` to move the cursor to the next or previous selection of `copilot`.

For example when you use `gr` to go to references of a function or a variable, there may be a selection list (if there is not only one reference), and you can use `j` and `k` to move the cursor to the next or previous selection. But when you use `<C-P>` to find files, in this case `j` and `k` will input letter j and letter k, so you can use `<C-J>` and `<C-K>` to move the cursor to the next or previous selection.

## Markdown Helper
These settings only work in a markdown file.

Some of the settings below will insert `<++>` as a placeholder symbol, and you can use `,f` to move the cursor out of the current block and remove the placeholder symbol.

| Shortcut | Mode | Description                                                                      |
| -        | -    | -                                                                                |
| ,f       | I    | Move the cursor out of the current block and remove next placeholder symbol      |
| ,t       | I    | Insert command line block and leave the cursor where you can input the command   |
| ,b       | I    | Insert bold line block and leave the cursor where you can input the bold content |
| ,m       | I    | Insert math line block and leave the cursor where you can input the math         |
| ,M       | I    | Insert math block and leave the cursor where you can input the math              |
| ,c       | I    | Insert code block, and leave the cursor where you should input the code language |
| ,n       | I    | Insert a new line symbol of html                                                 |
