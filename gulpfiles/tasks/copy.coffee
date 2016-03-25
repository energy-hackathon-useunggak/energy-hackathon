gulp          = require 'gulp'
$             = require '../plugins/'

gulp.task 'copy:assets', ['clean:assets'], () ->
  if $.isDevelopment
    return gulp.src [
      'client/assets/fonts',
      'client/assets/images',
      'client/assets/js'
    ], read: false
    .pipe $.symlink ['dist/client/assets/fonts', 'dist/client/assets/images', 'dist/client/assets/js']
  else
    return gulp.src [
      'client/assets/fonts/**/*',
      'client/assets/images/**/*',
      'client/assets/js/**/*'
    ], base: 'client'
    .pipe $.if('**/assets/js/**/*', gulp.dest('dist/client'))
    .pipe gulp.dest('dist/public')

gulp.task 'link:resources', () ->
  gulp.src [
    'client/sitemap.xml',
    'client/sitemap-static.xml'
  ], read: false
  .pipe $.if !$.isDevelopment, $.symlink([
    'dist/public/sitemap.xml',
    'dist/public/sitemap-static.xml'
  ])

gulp.task 'copy:resources', () ->
  gulp.src [
    'client/*',
    '!client/sitemap*.xml',
    '!client/{app,assets,bower_components,components}'
  ]
  .pipe gulp.dest(if !$.isDevelopment then 'dist/public' else 'dist/client')

gulp.task 'link:bower', ['unlink:bower'], () ->
  gulp.src 'client/bower_components', read: false
  .pipe $.symlink('dist/client/bower_components')
  .pipe $.if !$.isDevelopment, $.symlink('dist/public/bower_components')

gulp.task 'copy:bowerAssets', () ->
  return if $.isDevelopment && !$.concatEnabled

  files = $._.filter $.bowerFiles(), (filePath) ->
    return ! filePath.match /\.(js|css)$/i

  gulp.src files
  .pipe $.if($.isDevelopment && $.concatEnabled,
    gulp.dest('dist/client/assets/bower-assets'),
    gulp.dest('dist/public/assets/bower-assets'));

gulp.task 'copy:server', () ->
  gulp.src [
    'schedule.js',
    'server.js',
    'keys/**/*',
    'lib/**/*',
    '!lib/**/*.coffee'
  ], base: '.'
  .pipe $.if $.isDevelopment, $.changed('dist')
  .pipe gulp.dest('dist')