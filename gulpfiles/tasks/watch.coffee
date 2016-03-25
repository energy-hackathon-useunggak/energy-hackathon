gulp          = require 'gulp'
$             = require '../plugins/'

gulp.task 'watch', () ->
  logger = (event) ->
    $.util.log "File #{event.path} was #{event.type}, running tasks..."

  # copy - js:client
  gulp.watch [
    'client/{app,components}/**/*.js'
  ], interval: 500, ['js:client']
  .on 'change', logger

  # rebuild:coffee:client
  gulp.watch [
    'client/{app,assets,components}/**/*.coffee',
    '!client/{app,assets,components}/**/*.{spec,mock}.coffee'
  ], interval: 500, ['coffee:client']
  .on 'change', logger

  # rebuild:sass (w/o partials)
  gulp.watch [
    'client/{app,components}/**/*.sass',
    '!client/{app,components}/**/_*.sass'
  ], interval: 500, ['sass']
  .on 'change', logger

  # rebuild:sass (only partials, mixins, etc)
  # will perform full build instead of incremental build
  gulp.watch [
    'client/{app,assets,components}/**/_*.sass'
    'client/assets/**/*.sass'
  ], interval: 500, () ->
    $.runSequence 'clean:sass', 'sass'
  .on 'change', logger

  # rebuild:jade
  gulp.watch [
    'client/{app,components}/**/*.jade'
  ], interval: 500, ['jade']
  .on 'change', logger

  # rebuild:inject
  # rebuild:usemin
  gulp.watch [
    'client/index.html',
    'bower.json',
    'dist/client/{assets,app,components}/**/*.js'
    'dist/client/{assets,app,components}/**/*.html'
    'dist/client/{assets,app,components}/**/*.css'
    'dist/client/bower_components/*/bower.json',
    '!dist/client/app/config.js'
  ], interval: 500, () ->
    $.runSequence 'usemin', () ->
      return unless $.browserSyncEnabled
      $.browserSync.reload()
  .on 'change', logger

  # rebuild:coffee:server
  gulp.watch [
    'lib/**/*.coffee'
    '!lib/**/*.spec.coffee',
    '!lib/**/*.mock.coffee'
  ], interval: 500, ['coffee:server']
  .on 'change', logger

  # express:reload
  gulp.watch [
    'dist/lib/**/*.js',
    'lib/**/*.js'
    'node_modules/*/package.json'
    '.env'
  ], interval: 500, ['express']
  .on 'change', logger