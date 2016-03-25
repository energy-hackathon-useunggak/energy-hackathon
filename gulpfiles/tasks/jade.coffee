gulp          = require 'gulp'
$             = require '../plugins/'
jade          = require 'jade'
sanitizeHtml  = require 'sanitize-html'


jade.filters.escape = (dirty) ->
  return sanitizeHtml dirty,
    allowedTags: []
    allowedAttributes: []

gulp.task 'jade', () ->
  gulp.src 'client/{app,components}/**/*.jade', base: '.'
  .pipe $.if $.isDevelopment, $.changed('dist', extension: '.html')
  .pipe $.if $.isDevelopment, $.ignoreError('jade')
  .pipe $.jade(jade: jade)
  .pipe $.if !$.isDevelopment, $.htmlmin
    collapseBooleanAttributes: true
    # collapseWhitespace: true
    removeAttributeQuotes: true
    removeEmptyAttributes: true
    # removeRedundantAttributes: true
    removeScriptTypeAttributes: true
    removeStyleLinkTypeAttributes: true
  .pipe $.if !$.isDevelopment, $.ngTemplate
    module: 'energyHackathonApp'
    transformUrl: (url) ->
      return (url || '').replace(/^.+client\//i, '').replace(/\.?html$/i, '.html')
  .pipe $.if !$.isDevelopment, gulp.dest('dist/client/app'), gulp.dest('dist')
