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
    this._installUpdateMac() if /^darwin/.test process.platform
    this._installUpdateWin() if /^win/.test process.platform
    this._installUpdateLinux() if /^linux/.test process.platform

  _installUpdateMac: ->
    execPath = process.execPath
    filePath = execPath.substr(0, execPath.lastIndexOf("\\"))
    appPath = path.normalize(execPath + "/../../../../../../..")
    downloadTarget = os.tmpdir() + "/" + ".update.zip"
    extractFolder = os.tmpdir() + "/update/"

    @emit "download-started"

    progressCb = (state) -> @emit("download-progress", state)

    await @_downloadUpdate downloadTarget,
      "#{@options.updateServer}/#{@options.remoteFilenameOSX}",
      progressCb, defer err

    if err?
      @emit "download-failed", err
      console.log err
      return

    @emit "download-finished"

    await @_extractUpdate downloadTarget, extractFolder, defer err
    if err?
      @emit "download-failed", err
      return
    await @_hideOriginalMac appPath, @options.osxAppName, defer err
    if err?
      @emit "download-failed", err
      return
    await @_copyUpdateMac @options.osxAppName,
     extractFolder, appPath, defer err
    if err?
      @emit "download-failed", err
      return

    @emit "update-installed"

  _downloadUpdate: (targetPath, remoteUrl, progressCb, doneCb) ->
    progress request remoteUrl
      .on 'progress', progressCb
      .on 'error', doneCb
      .pipe fs.createWriteStream targetPath
      .on 'close', doneCb

  _extractUpdate: (sourceZip, targetFolder, done) ->
    unzipper = new DecompressZip(sourceZip)
    unzipper.on 'error', done
    unzipper.on 'extract', (log) -> done(null)
    unzipper.extract({ path: targetFolder })

  _hideOriginalMac: (appPath, appName, cb) ->
    filename = appName + '.app'
    fs.rename appPath + '/' + filename, appPath + '/.' + filename, cb

  _copyUpdateMac: (appName, from, to, callback) ->
    wrench.copyDirRecursive from + '/' + appName + '.app',
     to + '/' + appName + '.app',
     {forceDelete: true},
     callback


  _installUpdateWin: () ->
    execPath = process.execPath
    appFolder = execPath.substr(0, execPath.lastIndexOf("\\"))
    downloadTarget = os.tmpdir() + "/" + ".update.zip"
    extractFolder = os.tmpdir() + "/update/"

    @emit "download-started"

    progressCb = (state) -> @emit("download-progress", state)

    await @_downloadUpdate downloadTarget,
      "#{@options.updateServer}/#{@options.remoteFilenameWin}",
      progressCb, defer err

    if err?
      @emit "download-failed", err
      return
    await @_extractUpdate downloadTarget, extractFolder, defer err
    if err?
      @emit "download-failed", err
      return
    wrench.copyDirSyncRecursive(extractFolder, appFolder, {
      forceDelete: true
    })
    @emit "update-installed"


  _installUpdateLinux: () ->
    execPath = process.execPath
    appFolder = execPath.substr(0, execPath.lastIndexOf("\\"))
    downloadTarget = os.tmpdir() + "/" + ".update.zip"
    extractFolder = os.tmpdir() + "/update/"

    @emit "download-started"

    progressCb = (state) -> @emit("download-progress", state)

    remoteUrl = "#{@options.updateServer}/#{@options.remoteFilenameLinux32}"
    if os.arch() == "x64"
      remoteUrl = "#{@options.updateServer}/#{@options.remoteFilenameLinux64}"

    await @_downloadUpdate downloadTarget,
      remoteUrl,
      progressCb, defer err

    if err?
      @emit "download-failed", err
      return
    await @_extractUpdate downloadTarget, extractFolder, defer err
    if err?
      @emit "download-failed", err
      return
    wrench.copyDirSyncRecursive(extractFolder, appFolder, {
      forceDelete: true
    })
    @emit "update-installed"


  isUpdateAvailable: (cb) ->
    options = @options
    request "#{@options.updateServer}/package.json", (error, response, body) ->
      if error?
        cb(error)
        return

      remotePackage = JSON.parse body
      remoteVersion = remotePackage.version
      cb(null, semver.lt(options.localVersion, remoteVersion))

  isInDev: ->
    return _.contains(require('fs').readdirSync('.'), '.git')

window.Updater = Updater
