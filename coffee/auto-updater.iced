semver = require 'semver'
request = require 'request'
progress = require 'request-progress'
path = require 'path'
os = require 'os'
fs = require 'fs'
wrench = require 'wrench'
_ = require 'lodash'
DecompressZip = require 'decompress-zip'
{EventEmitter} = require 'events'

class Updater extends EventEmitter
  constructor: (options) ->
    @options = {
      localVersion: "1.0.0"
      osxAppName: "node-webkit"
      updateServer: "http://localhost:8080"
      remoteFilenameOSX: "nw-osx-ia32.zip"
      remoteFilenameWin: "nw-win-ia32.zip"
      remoteFilenameLinux32: "nw-linux-ia32.zip"
      remoteFilenameLinux64: "nw-linux-x64.zip"
    }
    @options = _.extend @options, options
    console.log @options

  installUpdate: ->
    this._install_update_mac() if /^darwin/.test process.platform
    this._install_update_win() if /^win/.test process.platform
    this._install_update_linux() if /^linux/.test process.platform

  _install_update_mac: ->
    execPath = process.execPath
    filePath = execPath.substr(0, execPath.lastIndexOf("\\"))
    appPath = path.normalize(execPath + "/../../../../../../..")
    downloadTarget = os.tmpdir() + "/" + ".update.zip"
    extractFolder = os.tmpdir() + "/update/"

    @emit "download-started"

    progressCb = (state) -> @emit("download-progress", state)

    await @_download_update downloadTarget,
      "#{@options.updateServer}/#{@options.remoteFilenameOSX}",
      progressCb, defer err

    if err?
      @emit "download-failed", err
      console.log err
      return

    @emit "download-finished"

    await @_extract_update downloadTarget, extractFolder, defer err
    if err?
      @emit "download-failed", err
      return
    await @_hide_original_mac appPath, @options.osxAppName, defer err
    if err?
      @emit "download-failed", err
      return
    await @_copy_update_mac @options.osxAppName,
     extractFolder, appPath, defer err
    if err?
      @emit "download-failed", err
      return

    @emit "update-installed"

  _download_update: (targetPath, remoteUrl, progressCb, doneCb) ->
    progress request remoteUrl
      .on 'progress', progressCb
      .on 'error', doneCb
      .pipe fs.createWriteStream targetPath
      .on 'close', doneCb

  _extract_update: (sourceZip, targetFolder, done) ->
    unzipper = new DecompressZip(sourceZip)
    unzipper.on 'error', done
    unzipper.on 'extract', (log) -> done(null)
    unzipper.extract({ path: targetFolder })

  _hide_original_mac: (appPath, appName, cb) ->
    filename = appName + '.app'
    fs.rename appPath + '/' + filename, appPath + '/.' + filename, cb

  _copy_update_mac: (appName, from, to, callback) ->
    wrench.copyDirRecursive from + '/' + appName + '.app',
     to + '/' + appName + '.app',
     {forceDelete: true},
     callback


  _install_update_win: () ->

  _install_update_linux: () ->

  is_update_available: (cb) ->
    options = @options
    request "#{@options.updateServer}/package.json", (error, response, body) ->
      if error?
        cb(error)
        return

      remotePackage = JSON.parse body
      remoteVersion = remotePackage.version
      cb(null, semver.lt(options.localVersion, remoteVersion))

window.Updater = Updater
