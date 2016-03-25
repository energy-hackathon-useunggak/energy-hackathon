gulp          = require 'gulp'
$             = require '../plugins/'
_             = $._


expressProc = null

gulp.task 'kill:express', (done) ->
  return done() if expressProc is null

  onFail = (e) ->
    # `condition && method();` equal as `if (condition) { method(); }`
    expressProc && expressProc.removeAllListeners()
    expressProc = null
    done e
  onSuccess = () ->
    expressProc && expressProc.removeAllListeners()
    expressProc = null
    done()

  expressProc.once 'error', onFail
  .once 'exit', onSuccess
  .kill 'SIGKILL' # Send SIGKILL signal. equal as `kill -9 PID` in Linux


gulp.task 'express', ['kill:express'], (done) ->
  try
    expressProc = $.childProcess.spawn 'node',
      ['server.js'],
      stdio: 'inherit'
      cwd: $.path.join process.cwd(), 'dist'
      env: $.env
    expressProc.once 'exit', () ->
      expressProc && expressProc.removeAllListeners()
      expressProc = null
    done()
  catch e
    done e


killall = (list, done) ->
  for proc in list
    $.ps.kill proc.pid, (e) ->
      if e
        $.util.log '[WARN] Failed to kill target express process.'
        $.util.log e
      else
        $.util.log '[INFO] Express Instance was killed (pid: %s)', proc.pid

      return done() if proc.pid is list[list.length - 1].pid

gulp.task 'check:express', (done) ->
  return done() unless $.isDevelopment

  if process.platform is 'win32'
    return $.ps.lookup
      command: 'node'
      arguments: 'server.js'
      psargs: ['aux']
    , (e, list) ->
      return done(e) if e
      return done() unless list.length # there are no instances

      $.util.log '[INFO] There are %d of running express instances. Trying to kill...', list.length
      killall list, done


  # For POSIX Platforms
  $.childProcess.exec 'ps axo pid,command | grep node | grep server.js'
  , (e, stdout, stderr) ->
      if e
        return done(e) if e.code is 1 # Process was not found
        return done(e) # Something went wrong

      rows = stdout.split '\n'
      list = _.chain rows
        .compact()
        .reject (row) -> ~(row.indexOf 'ps axo')
        .map (row) ->
          cols = row.trim().split /\s+/

          proc =
            pid: cols.shift()
            command: cols.join ' '

          return proc
      list = list.value()

      return done() unless list.length

      $.util.log '[INFO] There are %d of running express instances. Trying to kill...', list.length
      killall list, done