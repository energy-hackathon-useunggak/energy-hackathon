gulp          = require 'gulp'
$             = require '../plugins/'

gulp.task 'serve', ['build', 'kill:express'], (done) ->
  $.runSequence 'check:express', 'express', 'watch', () ->
    return done() unless $.browserSyncEnabled

    $.ensureExpressLoaded (e) ->
      return done(e) if e

      $.browserSync.init
        proxy: '127.0.0.1:9000'
        port: 3002
        notify: true
        ghostMode: false
        snippetOptions:
          rule :
            match : /<!-- browsersync -->/i
            fn : (snippet, match) ->
              match + snippet
      done()
