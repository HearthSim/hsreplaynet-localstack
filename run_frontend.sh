#!/bin/bash
yarn
yarn run webpack --devtool cheap-module-eval-source-map --env.cache --progress --watch
