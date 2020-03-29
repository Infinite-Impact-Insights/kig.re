#!/usr/bin/env bash
# vim: ft=bash

[[ -d ${HOME}/.bashmatic ]] || bash -c "$(curl -fsSL http://bit.ly/bashmatic-1-0-1)"

[[ -f ${HOME}/.bashmatic/init.sh ]] || {
  echo "Can't find or install Bashmatic. Exiting."
  exit 1
}

export NEWDIR="$(pwd -P)/_new_posts"

source ~/.bashmatic/init.sh

function post-rename() {
  local file="$*"
  local date="$(echo ${file} | sed 's/-[a-z].*$//g') 00:00:00 +08:00"
  local -a title_array=( $(echo $file | sed -E 's/^[0-9\-]+//g; s/\.(md|html)//g; s/-/ /g') )

  local title="${title_array[@]^}"

  local main_word=$(array.join '-' "${title_array[@]:0:5}")

  grep -q "layout: post" "${file}" && {
    info "File already converted: ${file}"
    run "cp ${file} ${NEWDIR}"
    return 0
  }

  local temp="/tmp/aaa"
  rm -f ${temp}

  cat > ${temp} <<HEADER
---
layout: post
title: "${title}"
date: "${date}"
post_image: /assets/images/posts/${main_word}.png
tags: [coding]
categories: [programming]
author_id: 1
comments: true
excerpt: "TODO"
---

HEADER

  sed ' 1,/^---$/d' "${file}" | \
    sed -E '/{{site.data.macros.continue}}/d' | \
    cat -s >> ${temp}

  run "mv ${temp} ${NEWDIR}/${file}"
}

posts.each() {
  local function="$1"

  util.is-a-function ${function} || {
    error "${function} is not a function."
    exit 1
  }

  run "mkdir -p ${NEWDIR}"

  run "cd _posts"

  for file in $(ls -1 *); do
    local code="${function} ${file}"
    info "eval ${code}"
    eval "${code}"
  done

  run "cd -"
}

posts.each post-rename
