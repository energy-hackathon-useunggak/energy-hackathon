gulp          = require 'gulp'
$             = require '../plugins/'

gulp.task 'coffee:server', () ->
  gulp.src [
    'lib/**/*.coffee'
    '!lib/**/*.{spec,mock}.coffee'], base: '.'
  .pipe $.if $.isDevelopment, $.changed('dist', extension: '.js')
  .pipe $.if $.isDevelopment, $.ignoreError('coffee:server')
  .pipe $.iced()
  .pipe gulp.dest('dist')

gulp.task 'coffee:client', () ->
  gulp.src [
    'client/{app,assets,components}/**/*.coffee',
    '!client/{app,assets,components}/**/*.{spec,mock}.coffee'
  ], base: '.'
  .pipe $.if $.isDevelopment, $.changed('dist', extension: '.js')
  .pipe $.if $.isDevelopment, $.ignoreError('coffee:client')
  .pipe $.coffee()
  .pipe gulp.dest('dist')