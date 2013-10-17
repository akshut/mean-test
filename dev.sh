#!/bin/bash

./node_modules/.bin/coffee -wc ./public/js/&
COFFEE_PID=$!

function teardown {
  kill $COFFEE_PID
  exit
}

trap teardown 2 3 6

./node_modules/.bin/node-dev server.coffee
