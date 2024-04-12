# dotfiles
My own configue files for UNIX/Linux tools.

You can use `./dot_files.py update` to append contents to the `$HOME` directory automatically, and see the file for more details.

You can use `./dot_files.py recover` to copy the backed up files to `$HOME` directory automatically, and see the file for more detaials.

NOTE: There are `start_symbol_kaiserqzyue` and `end_symbol_kaiserqzyue` in every dot file. If you want to recover the dot files, you just need to delete contents from `start_symbol_kaiserqzyue` till `end_symbol_kaiserqzyue`. You can do this by `vim` easily: `gg/start_symbol_kaiserqzyue<Enter>d/end_symbol_kaiserqzyue<Enter>dd`. Besides, you can use `./dot_files.py recover` to recover, if your dot files have been updated after using `./dot_files.py update`.