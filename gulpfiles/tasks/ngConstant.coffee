gulp          = require 'gulp'
$             = require '../plugins/'

gulp.task 'ngConstant', () ->
  $.ngConstant
    name: 'config'
    wrap: '"use strict";\n\n<%= __ngModule %>'
    space: '  '
    stream: true
    constants:
      ENV: $.env.FRONT_MODE
      BUILD_TARGET: $.NODE_ENV
      AWS_CLOUDFRONT_HOST: $.env.AWS_CLOUDFRONT_HOST
  .pipe $.rename('config.js')
  .pipe gulp.dest('dist/client/app')
