gulp          = require 'gulp'
requireDir    = require 'require-dir'
$             = require './gulpfiles/plugins/'


requireDir './gulpfiles/tasks'

$.util.log 'NODE_ENV: %s (isDevelopment? %s, concatEnabled? %s)', $.NODE_ENV, $.isDevelopment, $.concatEnabled
gulp.task 'default', ['serve']