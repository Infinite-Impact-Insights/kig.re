#!/usr/bin/env bash

bash -c "$(curl -fsSL https://bit.ly/bashmatic-1-2-0)"
source ~/.bashmatic/init.sh

[[ -z $(command -v bundle) ]] && run "gem install bundler"

run "bundle check || bundle install --jobs 4"

run.set-next show-output-on

run "bundle exec rake"


