gulp          = require 'gulp'
$             = require '../plugins/'


gulp.task 'build:client', ['js:client', 'coffee:client', 'sass', 'jade', 'ngConstant', 'copy:assets', 'link:bower', 'copy:resources', 'copy:bowerAssets', 'link:resources'], (done) ->
  $.runSequence 'usemin', 'compat', done

gulp.task 'build:server', ['coffee:server', 'copy:server']

gulp.task 'build', (done) ->
  $.runSequence ['clean:dist', 'clean:tmp'],
    ['build:client', 'build:server'],
    (if !$.isDevelopment then 'clean:client' else 'no-op')
  , done