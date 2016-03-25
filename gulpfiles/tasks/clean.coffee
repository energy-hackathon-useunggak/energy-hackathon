gulp          = require 'gulp'
$             = require '../plugins/'

# @note Full cleanup
gulp.task 'clean', () ->
  gulp.src 'dist', read: false
  .pipe $.rimraf

# @note Full cleanup except linked dirs
gulp.task 'clean:dist', () ->
# DO NOT FOLLOW SYMLINKS TO PREVENT DELETING LINKED DIRS WHICH
# AUTOMATICALLY CREATED BY CAPISTRANO.
  gulp.src [
    'dist/*',
    'dist/public/*',
    '!dist/public',
    '!dist/public/{emails,pc_app,uploads}'
  ], base: '.', read: false, follow: false
  .pipe $.rimraf()

gulp.task 'clean:tmp', () ->
  gulp.src '.tmp', read: false
  .pipe $.rimraf()

gulp.task 'clean:client', () ->
  gulp.src 'dist/client', read:false
  .pipe $.rimraf()

gulp.task 'clean:assets', () ->
  if $.isDevelopment
    gulp.src [
      'dist/client/assets/{fonts,images,js}',
      'dist/client/assets/common-styles/**/*'
    ], read: false
    .pipe $.rimraf()
  else
    gulp.src 'dist/client/assets/**/*', read: false
    .pipe $.rimraf()

gulp.task 'unlink:bower', () ->
  gulp.src 'dist/client/bower_components', read: false
  .pipe $.rimraf()

gulp.task 'clean:sass', () ->
  gulp.src [
    'dist/client/assets/common-styles/**/*.css',
    'dist/client/{app,components}/**/*.css'], read: false
  .pipe $.rimraf()