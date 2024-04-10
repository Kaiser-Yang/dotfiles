#!/usr/bin/env python

# Usage: ./update_dot_files.py or python update_dot_files.py
# Function: Back up $HOME/file to ./backup,
#           append all the contents of ./file to $HOME/file

# Update the list to ignore those files you don't want to update
# NOTE: items must start with ./ and end with no / at the end,
#       for example, ./backup means a file named backup in current directory or
#       a directory named backup in current directory
ignore_file = set(["./.git", "./LICENSE", "./README.md", "./update_dot_files.py",
                   "./.gitignore"])

# Update the string to specify where you want to store the backed-up files
backup_dir = "./backup"

import os
import shutil

# We don't backup backup directory
ignore_file.add(backup_dir)

backup_dir += '/'
home_dir = os.environ["HOME"] + '/'

def update_dot_files(home_current_dir : str, current_dir : str):
    global backup_dir, ignore_file, home_dir
    if not os.path.exists(backup_dir):
        os.mkdir(backup_dir)
    if not os.path.exists(home_current_dir):
        os.mkdir(home_current_dir)
    home_file_set = set(os.listdir(home_current_dir))
    cur_file_set = set(os.listdir(current_dir))
    backup_file_set = home_file_set & cur_file_set
    for backup_file in backup_file_set:
        if backup_file == '.' or backup_file == "..":
            continue
        if current_dir + backup_file in ignore_file:
            continue
        if os.path.isfile(home_current_dir + backup_file):
            print(f"backup {home_current_dir + backup_file} to "
                  f"{backup_dir + backup_file}")
            shutil.copy(home_current_dir + backup_file,
                        backup_dir + backup_file)
        else:
            backup_file += '/'
            backup_dir += backup_file
            update_dot_files(home_current_dir + backup_file,
                           current_dir + backup_file)
            backup_dir -= backup_file
    for cur_file in cur_file_set:
        if cur_file == '.' or cur_file == "..":
            continue
        if current_dir + cur_file in ignore_file:
            continue
        if os.path.isfile(current_dir + cur_file):
            print(f"append contents of "
                  f"{os.getcwd() + '/' + current_dir + cur_file} "
                  f"to {home_dir + cur_file}")
            os.system(f"cat {os.getcwd() + '/' + current_dir + cur_file} "
                      f">> {home_current_dir + cur_file}")
        else:
            print(cur_file)
            cur_file += '/'
            update_dot_files(home_current_dir + cur_file, current_dir + cur_file)            
      
if __name__ == "__main__":
    home_dir.replace("//", "/")
    update_dot_files(home_dir, './')
