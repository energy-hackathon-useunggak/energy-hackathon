# Module dependencies.
env             = require 'node-env-file'
_               = require 'underscore'

pluginMappings =
  'gulp-iced-coffee': 'iced'
  'gulp-angular-templatecache': 'ngTemplate'
# gulp plugins which starting with `gulp-` will
# automatically bound into the magic `$` variable.
# e.g. require('gulp-sass') -> $.sass
$ = module.exports = exports = require('gulp-load-plugins')(rename: pluginMappings)

# Expose environment variables
env './.env'
$.env           = process.env
$.NODE_ENV      = process.env.NODE_ENV || 'development'
$.isDevelopment = $.NODE_ENV is 'development'
$.concatEnabled = _.contains process.argv, '--enable-concat'
$.browserSyncEnabled = !_.contains(process.argv, '--disable-browser-sync')


# Expose node native modules
$.fs            = require 'fs'
$.path          = require 'path'
$.childProcess  = require 'child_process'


# Expose external npm modules
$._             = _
$.kue           = require 'kue'
$.moment        = require 'moment'
$.request       = require 'request'
$.bowerFiles    = require 'main-bower-files'
$.glob          = require 'glob'
$.del           = require 'del'
$.runSequence   = require 'run-sequence'
$.lazypipe      = require 'lazypipe'
$.vinylPaths    = require 'vinyl-paths'
$.reworkUrl     = require 'rework-plugin-url'
$.ps            = require 'ps-node'
$.browserSync   = require('browser-sync').create()


# Expose user-created stream-based plugins
$.rimraf        = $.lazypipe()
  .pipe () ->
    return $.plumber()
  .pipe () ->
    return $.vinylPaths $.del

$.rebaseCSSUrl = $.lazypipe()
  .pipe () ->
    return $.rework $.reworkUrl (url) ->
      return url if url.match /^data:/i # keep url if url is Data URI
      return url if url.match /^http/i # keep url if url is Full URL
      return url if url.match /^\// # keep url if url is absolute path

      # remove all of parent path references
      # and prepend asset path
      return '/assets/bower-assets/' + $.path.basename url

$.ignoreError = (name) ->
  $.plumber(error: (e) ->
    $.util.log 'An error occurred during `%s` task.', name, e
    $.util.log 'Ignoring error...')


# Expose user-created functions
$.ensureExpressLoaded = (cb) ->
  MAX_ATTEMPT_COUNT = 10
  count = 0
  check = () ->
    $.request
      method: 'GET'
      url: 'http://www.lvh.me:9000'
      timeout: 4000 # 4 sec
    , (e, r, body) ->
      return cb() if !e && r.statusCode is 200

      return cb new Error('Maximum attempt count leeched. Did you check Express server is running?') if ++count > MAX_ATTEMPT_COUNT

      $.util.log 'Express server still not loaded... waiting...'
      setTimeout check, 1000
  check()
