#!/usr/bin/env bash

function frolic::newname() { 
  echo $1 | sed 's/ /-/g' | tr 'A-Z' 'a-z' | sed 's/frolic-2018-//g;s/---/./g' 
}

function frolic::rename() {
  local pattern="$1"
  [[ -z "${pattern}" ]] && pattern="*.mp3"
  OLD_IFS="${IFS}"
  IFS='|'
  declare -a files=($(ls -1 ${pattern} | tr '\n' '|'))
  for file in ${files[@]}; do 
    nfile=$(frolic::newname "${file}")
    if [[ "${nfile}" == "${file}" ]]; then
      printf "File already converted: ${bldgrn}${nfile}\n"
      continue
    fi
    if [[ -f "${file}" ]]; then 
      printf "${bldylw}%40s -> ${bldgrn}%40s\n" "${file}" "${nfile}"
      mv "${file}" "${nfile}"
    else
      printf "${bldred}File not found: ${bldylw}${file}\n"
    fi
  done
  IFS="${OLD_IFS}"
}

frolic::rename "$@"

