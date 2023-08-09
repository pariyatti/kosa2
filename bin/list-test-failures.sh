#!/usr/bin/env bash

RAILS_TEST_ENV=smoke bundle exec rake test:all &> test.log

egrep -i -C3 'error|fail' test.log
