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
sed -r 's/(\[.+\])\(([^)]+)\)/\1(\2.html)/g' <"$INPUT" | pandoc $MATH -s -f $SYNTAX -t html -c $CSSFILENAME --metadata pagetitle="$FILE" | sed -r 's/<li>(.*)\[ \]/<li class="todo done0">\1/g; s/<li>(.*)\[X\]/<li class="todo done4">\1/g' > "$OUTPUT"

