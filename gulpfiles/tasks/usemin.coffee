gulp          = require 'gulp'
$             = require '../plugins/'

minifyCssOptions =
  processImport: false
  restructuring: false

gulp.task 'usemin', () ->
  jsApp = $.glob.sync 'client/app/**/*.js',
    cwd: 'dist', ignore: [
      'client/app/app.js',
      'client/app/**/*.{spec,mock}.js'
    ]

  jsComponents = $.glob.sync 'client/components/**/*.js',
    cwd: 'dist', ignore: [
      'client/components/**/*.{spec,mock}.js'
    ]

  sassApp = $.glob.sync 'client/app/**/*.css',
    cwd: 'dist', ignore: [
      'client/app/**/_*.css'
    ]

  sassComponents = $.glob.sync 'client/{assets,components}/**/*.css',
    cwd: 'dist', ignore: [
      'client/{assets,components}/**/_*.css'
    ]

  # @task Inject with usemin
  gulp.src 'client/index.html'

  # bower-install
  .pipe $.inject gulp.src($.bowerFiles(), read: false)
  , relative: false, name: 'bower', ignorePath: 'client'

  # injector:jsApp
  .pipe $.inject gulp.src(jsApp, base: 'client', cwd: 'dist', read: false)
  , relative: false, name: 'jsApp', ignorePath: 'client'

  # injector:jsComponents
  .pipe $.inject gulp.src(jsComponents, base: 'client', cwd: 'dist', read: false)
  , relative: false, name: 'jsComponents', ignorePath: 'client'

  # injector:sassApp
  .pipe $.inject gulp.src(sassApp, base: 'client', cwd: 'dist', read: false)
  , relative: false, name: 'sassApp', ignorePath: 'client'

  # injector:sassComponents
  .pipe $.inject gulp.src(sassComponents, base: 'client', cwd: 'dist', read: false)
  , relative: false, name: 'sassComponents', ignorePath: 'client'
  .pipe $.template $.env
  .pipe gulp.dest('dist')
  .pipe $.if !$.isDevelopment, $.usemin
    'vendorCss': [
      $.rebaseCSSUrl(),
      $.size(title: 'vendorCss - before build'),
      $.if('!**/*[.-_]min.css', $.minifyCss(minifyCssOptions)),
      'concat',
      $.size(title: 'vendorCss - after build'),
      $.rev()
    ],
    'appCss': [
      $.size(title: 'appCss - before build'),
      'concat',
      $.minifyCss(minifyCssOptions),
      $.size(title: 'appCss - after build'),
      $.rev()
    ],
    'componentsCss': [
      $.size(title: 'componentsCss - before build'),
      'concat',
      $.minifyCss(minifyCssOptions),
      $.size(title: 'componentsCss - after build'),
      $.rev()
    ],
    'polyfillJs': ['concat'],
    'vendorJs': [
      $.size(title: 'vendorJs - before build'),
      $.if('!**/*[.-_]min.js', $.uglify()),
      'concat',
      $.size(title: 'vendorJs - after build'),
      $.rev()
    ],
    'appJs': [
      'concat',
      $.size(title: 'appJs - before build'),
      $.ngAnnotate(),
      $.sourcemaps.init(),
      $.uglify(
        compress:
          drop_console: true
      ),
      $.rev(),
      $.sourcemaps.write('sourcemaps'),
      $.size(title: 'appJs - after build')
    ],
    'componentsJs': [
      'concat',
      $.size(title: 'componentsJs - before build'),
      $.ngAnnotate(),
      $.sourcemaps.init(),
      $.uglify(
        compress:
          drop_console: true
      ),
      $.rev(),
      $.sourcemaps.write('sourcemaps'),
      $.size(title: 'componentsJs - after build')
    ]
  .pipe $.if $.isDevelopment && $.concatEnabled, $.usemin
    'vendorCss': [$.rebaseCSSUrl(), 'concat'],
    'appCss': ['concat'],
    'componentsCss': ['concat'],
    'polyfillJs': ['concat'],
    'vendorJs': ['concat'],
    'appJs': ['concat'],
    'componentsJs': ['concat']
  # Save injected results
  .pipe $.if !$.isDevelopment, gulp.dest('dist/public'), gulp.dest('dist/client')
