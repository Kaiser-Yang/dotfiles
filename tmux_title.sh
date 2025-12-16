#!/bin/bash
p=$1
h=$HOME
if [ "${p#"$h"}" != "$p" ]; then
  p="~${p#"$h"}";
fi;
IFS=/ read -ra parts <<< "$p";
out="";
for ((i=0; i<${#parts[@]}; ++i)); do
  if ((i == ${#parts[@]}-1)); then
    out+="${parts[i]}";
  elif [[ ${parts[i]} == .* ]]; then
    out+="${parts[i]:0:2}/";
  else
    out+="${parts[i]:0:1}/";
  fi;
done;
echo "$out"
