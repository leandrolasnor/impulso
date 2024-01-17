#!/usr/bin/env zsh
set -e
yarn --cwd ./reacting install
bundle
bundle exec rake db:migrate
bundle exec rake db:seed
exec "$@"