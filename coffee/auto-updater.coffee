semver = require 'semver'
request = require 'request'
progress = require 'request-progress'
path = require 'path'
os = require 'os'
fs = require 'fs'
wrench = require 'wrench'
DecompressZip = require 'decompress-zip'

packageFile = require './package.json'



updateServer = packageFile.remoteUpdateUrl
localVersion = packageFile.version

class Updater
  update: (cb) ->
    this._update_mac cb if /^darwin/.test process.platform
    this._update_win cb if /^win/.test process.platform
    this._update_linux cb if /^linux/.test process.platform

  _update_mac: (cb) ->
    execPath = process.execPath
    filePath = execPath.substr(0, execPath.lastIndexOf("\\"))
    appName = "Rockband Keyboard"
    appPath = path.normalize(execPath + "/../../../../../../..")
    downloadTarget = os.tmpdir() + "/" + ".update.zip"
    extractFolder = os.tmpdir() + "/update/"
    self = this

    console.log "Requesting updates"
    this.is_update_available (err, update_available) ->
      if update_available
        self._download_update(downloadTarget,
         "#{updateServer}/#{packageFile.name}-osx-ia32.zip",
         (state) ->
           console.log state
        , () ->
          self._extract_update downloadTarget, extractFolder, (err) ->
            console.log err
            self._hide_original_mac(appPath, appName, (err) ->
              self._copy_update_mac appName, extractFolder, appPath, cb
            )
        )
      else
        console.log "No updates."

  _download_update: (targetPath, remoteUrl, progressCb, doneCb) ->
    progress(request(remoteUrl))
      .on('progress', progressCb)
      .on('error', doneCb)
      .pipe(fs.createWriteStream(targetPath))
      .on('close', doneCb)

  _extract_update: (sourceZip, targetFolder, done) ->
    unzipper = new DecompressZip(sourceZip)
    unzipper.on 'error', done
    unzipper.on 'extract', (log) -> done(null)
    unzipper.extract({
      path: targetFolder
      })

  _hide_original_mac: (appPath, appName, cb) ->
    filename = appName + '.app'
    fs.rename(appPath + '/' + filename, appPath + '/.' + filename, cb)

  _copy_update_mac: (appName, from, to, callback) ->
    wrench.copyDirRecursive(
      from + '/' + appName + '.app',
      to + '/' + appName + '.app',
      {forceDelete: true},
      callback)


  _update_win: (cb) ->

  _update_linux: (cb) ->

  is_update_available: (cb) ->
    request "#{updateServer}/package.json", (error, response, body) ->
      if error?
        cb(error)
        return

      remotePackage = JSON.parse body
      remoteVersion = remotePackage.version
      cb(null, semver.lt(localVersion, remoteVersion))

window.Updater = Updater
