#!/bin/sh

set -e

if [ "$RAILS_ENV" == "development" ]
then
  bundle exec rails db:create
  bundle exec rails db:migrate
  bundle exec rails db:seed
fi

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rails s -b 0.0.0.0
