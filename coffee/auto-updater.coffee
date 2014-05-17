semver = require 'semver'
request = require 'request'
progress = require 'request-progress'
path = require 'path'
os = require 'os'
fs = require 'fs'

packageFile = require './package.json'



updateServer = packageFile.remoteUpdateUrl
localVersion = packageFile.version

class Updater
  update: (cb) ->
    this._update_mac cb if /^darwin/.test process.platform
    this._update_win cb if /^win/.test process.platform
    this._update_linux cb if /^linux/.test process.platform

  _update_mac: (cb) ->
    execPath = "." #process.execPath
    filePath = execPath.substr(0, execPath.lastIndexOf("\\"))
    appPath = path.normalize(execPath ) #+ "/../../../../../../..")
    downloadTarget = os.tmpdir() + "/" + ".update.zip"
    self = this

    console.log "Requesting updates"

    request "#{updateServer}/package.json", (error, response, body) ->
      console.log response
      if error
        cb(error)
        return

      remotePackage = JSON.parse body
      remoteVersion = remotePackage.version
      console.log "Remote Version: #{remoteVersion}"
      if semver.lt(localVersion, remoteVersion)
        console.log "Remote is newer!"
        self._download_update(downloadTarget,
         "#{updateServer}/#{packageFile.name}-osx-ia32.zip",
         (state) ->
           console.log state
        , cb)
      else
        console.log "No updates."

  _download_update: (targetPath, remoteUrl, progressCb, doneCb) ->
    progress(request(remoteUrl))
      .on('progress', progressCb)
      .on('error', doneCb)
      .pipe(fs.createWriteStream(targetPath))
      .on('close', doneCb)


  _update_win: (cb) ->

  _update_linux: (cb) ->

window.Updater = Updater
