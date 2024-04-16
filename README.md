# dotfiles
My own configure files for UNIX/Linux tools.

You can use `./dot_files.py update` to append contents to the `$HOME` directory automatically, and see the file for more details.

You can use `./dot_files.py recover` to copy the backed up files to `$HOME` directory automatically, and see the file for more details.

You can use `./dot_files.py`, which is same with `./dot_files.py recover && ./dot_files.py update`.

You can use `./dot_files.py init` for the first time install, which will install all plugins for vim and install fish and then set fith be your default shell, see the file for more details.

NOTE: if you want to use `./dot_files.py init`, be sure your conda is deactivated (there is no base or other conda name on your screen), and make sure you have `Python` order than `3.8` locally, because `ycm` can not be installed by this script within conda.

NOTE: There are `start_symbol_kaiserqzyue` and `end_symbol_kaiserqzyue` in every dot file. If you want to recover the dot files, you just need to delete contents from `start_symbol_kaiserqzyue` till `end_symbol_kaiserqzyue`. You can do this by `vim` easily: `gg/start_symbol_kaiserqzyue<Enter>d/end_symbol_kaiserqzyue<Enter>dd`. Besides, you can use `./dot_files.py recover` to recover, if your dot files have been updated after using `./dot_files.py update`.
