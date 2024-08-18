#!/usr/bin/bash
# this file updates form https://gist.github.com/enpassant/0496e3db19e32e110edca03647c36541
# before use this, please make sure you have pandoc

FORCE="$1"
SYNTAX="$2"
EXTENSION="$3"
OUTPUTDIR="$4"
INPUT="$5"
CSSFILE="$6"

# FILE is filename with extension
FILE=$(basename "$INPUT")
# FILENAME is filename without extension
FILENAME=$(basename "$INPUT" ."$EXTENSION")
# OUTPUT includes the output file's absolute path, filename and extension
OUTPUT="$OUTPUTDIR"/$FILENAME.html
CSSFILENAME=$(basename "$CSSFILE")
HAS_MATH=$(grep -o "\$\$.\+\$\$" "$INPUT")
# non-zero use MATH
if [ -n "$HAS_MATH" ]; then
    MATH="--mathjax=https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
else
    MATH=""
fi
# find []() and ![]() won't match, because ![]() is image link, we should ignore this.
# and there is no any dot your base filename,
# Then we add .html at the end of ().
# e.g. [abc](abc) will not be chagned
# e.g. ![abc](abc) will not be chagned.
# e.g. [abc](http://test.com) will not be changed.
# e.g. [abc](abc-def.md) will be changed to [abc](abc-def.html)
# this is mainly making the links work in html files.
# This works not perfectly, but it works for me.
sed -r 's/^[^!]*(\[.+\])\(([^/]+?)\.md\)/\1(\2.html)/g' < "$INPUT" \
| pandoc "$MATH" -s -f "$SYNTAX" -t html -c "$CSSFILENAME" --metadata pagetitle="$FILE" \
> "$OUTPUT"
