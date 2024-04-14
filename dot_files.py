#!/usr/bin/env python

# Usage: ./dot_files.py update|recover or python dot_files.py update|recover
# Update Function: Back up $HOME/file to ./backup,
#                  append all the contents of ./file to $HOME/file or
#                  copy ./file to $HOME/
# Recover Function: copy ./backup/file to $HOME/

# Update the list to ignore those files you don't want to update or recover
# NOTE: items must start with ./ and end with no / at the end,
#       for example, ./backup means a file named backup in current directory or
#       a directory named backup in current directory
ignore_file = set(["./.git", "./LICENSE", "./README.md",
                   "./dot_files.py", "./.gitignore"])

# Update the list to let those files to be copied to $HOME
copy_file = set(["./.vscode-server", "./.vimrc", "./.vim",
                 "./vim_plugin_config"])
# Update the string to specify where you want to store the backed-up files
# or where you want to recover from
backup_dir = "./backup"

import os
import shutil
import sys

# We don't backup backup directory
ignore_file.add(backup_dir)

backup_dir += '/'
home_dir = os.environ["HOME"] + '/'

def backup_files(home_current_dir : str, current_dir):
    global backup_dir, ignore_file, home_dir
    if not os.path.exists(backup_dir):
        os.mkdir(backup_dir)
    home_file_set = set(os.listdir(home_current_dir))
    cur_file_set = set(os.listdir(current_dir))
    backup_file_set = home_file_set & cur_file_set
    for fileOrDir in backup_file_set:
        if fileOrDir == '.' or fileOrDir == "..":
            continue
        if current_dir + fileOrDir in ignore_file:
            continue
        if os.path.isfile(home_current_dir + fileOrDir):
            print(f"backup {home_current_dir + fileOrDir} to "
                  f"{backup_dir + fileOrDir}")
            shutil.copy(home_current_dir + fileOrDir,
                        backup_dir + fileOrDir)
        else:
            fileOrDir += '/'
            backup_dir += fileOrDir
            backup_files(home_current_dir + fileOrDir,
                         current_dir + fileOrDir)
            backup_dir = backup_dir[:-len(fileOrDir)] 

def update_dot_files(home_current_dir : str, current_dir : str):
    if not os.path.exists(home_current_dir):
        os.mkdir(home_current_dir)
    cur_file_set = set(os.listdir(current_dir))
    for fileOrDir in cur_file_set:
        if fileOrDir == '.' or fileOrDir == "..":
            continue
        if current_dir + fileOrDir in ignore_file:
            continue
        if os.path.isfile(current_dir + fileOrDir):
            if current_dir + fileOrDir in copy_file:
                print(f"copy "
                        f"{current_dir + fileOrDir} "
                        f"to {home_current_dir + fileOrDir}")
                shutil.copy(current_dir + fileOrDir,
                            home_current_dir + fileOrDir)
            else:
                print(f"append contents of "
                        f"{os.getcwd() + '/' + current_dir + fileOrDir} "
                        f"to {home_current_dir + fileOrDir}")
                os.system(f"cat {os.getcwd() + '/' + current_dir + fileOrDir} "
                            f">> {home_current_dir + fileOrDir}")
        elif current_dir + fileOrDir in copy_file:
            if not os.path.exists(home_current_dir + fileOrDir):
                os.mkdir(home_current_dir + fileOrDir)
            print("cp -r " 
                  f"{os.getcwd() + '/' + current_dir + fileOrDir + '/*'} " 
                  f"{home_current_dir + fileOrDir}")
            os.system("cp -r " 
                      f"{os.getcwd() + '/' + current_dir + fileOrDir + '/*'} " 
                      f"{home_current_dir + fileOrDir}")
        else:
            fileOrDir += '/'
            update_dot_files(home_current_dir + fileOrDir,
                             current_dir + fileOrDir)

def recover_dot_files(home_current_dir, current_dir):
    global backup_dir, ignore_file, home_dir
    if not os.path.exists(home_current_dir):
       os.mkdir(home_current_dir)
    recover_file_set = set(os.listdir(backup_dir + current_dir)) 
    for recover_file in recover_file_set:
        if recover_file == '.' or recover_file == "..":
            continue
        if current_dir + recover_file in ignore_file:
            continue
        if os.path.isfile(backup_dir + current_dir + recover_file):
            print(f"recover {backup_dir + current_dir + recover_file} to "
                  f"{home_current_dir}")
            shutil.copy(backup_dir + current_dir + recover_file,
                        home_current_dir)
        else:
            recover_file += '/'
            recover_dot_files(home_current_dir + recover_file,
                             current_dir + recover_file)
        
def update_or_recover_dot_files(home_current_dir : str, current_dir : str,
                                opcode : str):
    if opcode == "update":
        backup_files(home_current_dir, current_dir)
        update_dot_files(home_current_dir, current_dir)
    elif opcode == "recover":
        recover_dot_files(home_current_dir, current_dir)
    else:
        exit(1)      

if __name__ == "__main__":
    if (len(sys.argv) != 2 or
        (sys.argv[1] != "update" and sys.argv[1] != "recover")):
        print("Usage: ./dot_files.py update|recover")
    home_dir.replace("//", "/")
    update_or_recover_dot_files(home_dir, "./", sys.argv[1])
