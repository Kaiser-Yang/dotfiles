#!/usr/bin/env python3

# Usage: python dot_files.py [update|recover|init]
# Update Function: Back up $HOME/file to ./backup,
#                  append all the contents of ./file to $HOME/file or
#                  copy ./file to $HOME/
# Recover Function: copy ./backup/file to $HOME/
# No Args: this will recover, backup and update.
# NOTE: any operation reference to update will overwrite the backup files,
#       so use ./dot_files.py with no args are strongly recommended.
# NOTE: do not run this code as root, even using sudo, otherwise, this will install in
#       user root's HOME DIRECTORY, which is usually set with /root

# Update the list to ignore those files you don't want to update or recover
# NOTE: items must start with ./ and end with no / at the end,
#       for example, ./backup means a file named backup in current directory or
#       a directory named backup in current directory
# NOTE: functionality of converting vimwiki to html needed pandoc,
#       and tasks_list are supported after pandoc 2.6,
#       you can use conda install pandoc for your activated conda environment,
#       if you do it, make sure when you want to convert files,
#       your conda environment is where you install pandoc,
#       if you never convert vimwiki to html files, you can ignore this.
# NOTE: make sure you conda environments are all deactived before runnint with init
ignore_file = set(["./.git", "./LICENSE", "./README.md",
                   "./dot_files.py", "./.gitignore", "./replace_md_image.py",
                   "./installer", "./vscode-setting", "./README.assets", "./markdownBackup"])

# Update the list to let those files to be copied to $HOME
# In short, if your $HOME has no the file or directory,
# Add it to the variable.
copy_file = set(["./.tmux.conf", "./proxy.sh", "./proxy.fish", "./.config/nvim", "./.local"])
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
    # this is to invent the backup_dir doesn't exists.
    if not os.path.exists(backup_dir + current_dir):
        return
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

def install_useful_softwares():
    os.system("cd installer && bash installer.sh")

def operate_dot_files(home_current_dir : str, current_dir : str,
                      opcode : str):
    if opcode == "update":
        backup_files(home_current_dir, current_dir)
        update_dot_files(home_current_dir, current_dir)
    elif opcode == "recover":
        recover_dot_files(home_current_dir, current_dir)
    elif opcode == "init":
        recover_dot_files(home_current_dir, current_dir)
        backup_files(home_current_dir, current_dir)
        update_dot_files(home_current_dir, current_dir)
        install_useful_softwares()
    elif opcode == "":
        recover_dot_files(home_current_dir, current_dir)
        backup_files(home_current_dir, current_dir)
        update_dot_files(home_current_dir, current_dir)
    else:
        print("Usage: ./dot_files.py [update|recover|init]")
        exit(1)

if __name__ == "__main__":
    if os.getuid() == 0:
        while True:
            print("Warning: you are installing for user root,"
                  "which is uncommon, are you sure to continue?[y/N]", end = '')
            confirm = input().lower()
            if confirm == 'n':
                exit(0)
            elif confirm == 'y':
                break
    if len(sys.argv) == 2:
        opcode =  sys.argv[1]
    elif len(sys.argv) > 2:
        print("Usage: ./dot_files.py [update|recover|init]")
        exit(1)
    else:
        opcode = ""
    home_dir = home_dir.replace("//", "/")
    operate_dot_files(home_dir, "./", opcode)
