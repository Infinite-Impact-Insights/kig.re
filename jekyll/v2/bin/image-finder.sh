#!/usr/bin/env bash

source ~/.bashmatic/init.sh

for file in $(find assets/images/posts -type f) ;
  do name=$(basename ${file})
  ag ${name} --silent >/dev/null || {
    printf "${bldred}[ x ] ${txtblk}${file}${clr}\n"
    continue
  }
  printf "${bldgrn}[ ✓ ] ${bldylw}${file}${clr}\n${bldgrn}"]
  declare -a matches="$(ag --no-color -l --ignore-dir _site ${name})"
  array.join "        • " true ${matches[@]}
done

