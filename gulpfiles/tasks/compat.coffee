gulp          = require 'gulp'
$             = require '../plugins/'

gulp.task 'compat:bless', () ->
  return if $.NODE_ENV is 'development'

  gulp.src 'dist/public/app/*.css'
  .pipe $.bless
    log: true
    imports: false
  .pipe gulp.dest 'dist/public/app/compat'


gulp.task 'compat:inject', () ->
  return if $.NODE_ENV is 'development'

  gulp.src 'dist/public/index.html'
  .pipe $.inject gulp.src([
      'app/compat/vendor*.css',
      'app/compat/app*.css',
      'app/compat/components*.css',
      '!app/compat/*blessed*.css'
    ], base: 'public', cwd: 'dist/public', read: false)
  , relative: false, name: 'compat', removeTags: true

  # @note Below pipeline isn`t related with compat task
  # but keep content here instead of seprated files
  # due to performance reason. (single pipeline vs multi pipeline)
  .pipe $.replace /(href|src)="(\/(app|bower_components|assets)[^"]+)"/gi, '$1="' + process.env.AWS_CLOUDFRONT_HOST + '$2"'

  .pipe $.htmlmin
    removeComments: true
    collapseBooleanAttributes: true

  .pipe gulp.dest 'dist/public'


gulp.task 'compat', (done) ->
  $.runSequence 'compat:bless', 'compat:inject', done