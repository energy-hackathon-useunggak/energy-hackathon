gulp          = require 'gulp'
$             = require '../plugins/'

gulp.task 'sass', () ->
  gulp.src [
    'client/{app,assets,components}/**/*.sass',
    '!client/{app,assets,components}/**/_*.sass'
  ], base: '.'
  .pipe $.if $.isDevelopment, $.changed('dist', extension: '.css')
  .pipe $.if $.isDevelopment, $.ignoreError('sass')
  .pipe $.sass(
    sourceMap: true
    includePaths: [
      'client/bower_components/compass-mixins/lib',
      'client/assets/common-styles'
    ]).on('error', $.sass.logError)
  .pipe gulp.dest('dist')