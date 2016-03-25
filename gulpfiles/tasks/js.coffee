gulp          = require 'gulp'
$             = require '../plugins/'

gulp.task 'js:client', () ->
  gulp.src 'client/{app,components}/**/*.js', base: 'client'
  .pipe gulp.dest('dist/client')