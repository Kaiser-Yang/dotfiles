#!/usr/bin/env python3

# usage: python3 replace_md_image.py markdownFilesDir
# function: update the ![](http) with ![](filename.assets/picname)
#           this will download the file automatically.

import re
import os
import sys
import io
from shutil import copy
import requests

# the images in Markdown: ![img]()
# group 1 is the url or filename
global imgPattern
imgPattern = r'!\[.*\]\((.*)\)'

backupName = 'markdownBackup'

# find all the files in filenameList with .md extension
def getMarkdownFileList(directoryName):
    res = []
    for filename in os.listdir(directoryName):
        fileWithPath = os.path.join(directoryName, filename)
        if os.path.isdir(fileWithPath) and filename != backupName:
            res.extend(getMarkdownFileList(fileWithPath))
        elif os.path.isfile(fileWithPath) and fileWithPath.endswith('.md'):
            res.append(fileWithPath)
    return res

# copy src to dest
# return the dest with the filename
def copyFile(src: str, dest: str):
    try:
        copy(src, dest)
    except IOError:
        print(f"fail to copy {src} to {dest}")
        return None
    except:
        print(f"fail to copy {src} to {dest}")
        return None
    return os.path.join(dest, os.path.basename(src))

# download from url to dir
# return the downloaded filename without path
def download(url: str, dir: str) -> str:
    r = requests.get(url)
    # get original filename
    dest = os.path.join(dir, url.split('/')[-1])
    # remove parameters
    endPos = dest.rfind('?')
    if endPos == -1:
        endPos = len(dest)
    dest = dest[0:endPos]
    with open(dest, "wb") as f:
        f.write(r.content)
    return dest

# download from url and substitude with local filename
def processMarkdownFile(markdownFileList):
    for markdownFilename in markdownFileList:
        # markdownFilename.assets directory
        dirName = os.path.dirname(markdownFilename)
        dirName = os.path.join(dirName, os.path.splitext(markdownFilename)[0])
        dirName += '.assets'
        # open with utf-8
        with io.open(markdownFilename, 'r', encoding='utf-8') as f:
            imageDir = os.path.splitext(os.path.basename(markdownFilename))[0] + '.assets'
            numReplace = 0
            content = f.read()
            matches = re.compile(imgPattern).findall(content)
            if matches == None or len(matches) == 0:
                continue
            for match in matches:
                if match == None or len(match) == 0:
                    continue
                newPath = None
                # only download url started with http, this will download https too.
                print(match)
                if match[0:4] != 'http':
                    continue
                if not os.path.exists(dirName):
                    os.makedirs(dirName)
                newPath = download(match, dirName)
                relativePath = os.path.join(imageDir, os.path.basename(newPath))
                # substitude url with local path
                content = content.replace(match, relativePath)
                numReplace += 1

            if content and numReplace > 0:
                io.open(markdownFilename, 'w', encoding='utf-8').write(content)
                print(f'{os.path.basename(markdownFilename)}: {numReplace} URL(s) substituded.')
            elif numReplace == 0:
                print(f'{os.path.basename(markdownFilename)} has nothing to be substituded.')

# backup files before substitution
def backup(mdFilenames) -> bool:
    for mdFilename in mdFilenames:
        dest = os.path.join(os.path.dirname(mdFilename), backupName)
        print(f'backup {mdFilename} to {dest}')
        if not os.path.exists(dest):
            os.makedirs(dest)
        if not copyFile(mdFilename, dest):
            return False
    return True

if __name__ == '__main__':
    argc = len(sys.argv)
    if argc != 2:
        print('usage: python3 replace_md_image.py <markdownFilesDir>')
        exit(1)
    if not os.path.exists(sys.argv[1]):
        print(f'{sys.argv[1]} does not exist.')
        exit(1)
    os.chdir(sys.argv[1])
    mdFilenames = getMarkdownFileList(os.getcwd())
    print(mdFilenames)
    print('-----------------backup------------------')
    if not backup(mdFilenames):
        print('-------------backup failed---------------')
        exit(1)
    print('--------------backup succeed-------------')
    print('\n')
    print('----------------replace------------------')
    processMarkdownFile(mdFilenames)
    print('------------replace succeed--------------')
