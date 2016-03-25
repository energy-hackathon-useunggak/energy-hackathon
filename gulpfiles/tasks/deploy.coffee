gulp          = require 'gulp'
$             = require '../plugins/'


gulp.task 'publish:nginx', () ->
  if $.NODE_ENV isnt 'production'
    $.util.log 'Environment doesn`t seems production. skipping script...'
    return

  gulp.src 'dist/public'
  .pipe $.symlink '../../public', force: true


gulp.task 'deploy:before', ['publish:nginx']
gulp.task 'deploy:after', ['no-op']
