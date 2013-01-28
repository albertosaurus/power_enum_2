#!/bin/bash

# Make sure we're in the right path.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

export RAILS_ENV=test
cd ../spec/dummy
bundle exec rake db:create
bundle exec rake db:migrate

