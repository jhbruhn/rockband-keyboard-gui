packageFile = require './package.json'

updateServer = packageFile.remoteUpdateUrl
localVersion = packageFile.version

updaterOptions = {
  localVersion: localVersion
  osxAppName: "Rockband Keyboard"
  updateServer: updateServer
  remoteFilenameOSX: "rockband-keyboard-gui-osx-ia32.zip"
  remoteFilenameWin: "rockband-keyboard-gui-win-ia32.zip"
  remoteFilenameLinux32: "rockband-keyboard-gui-linux-ia32.zip"
  remoteFilenameLinux64: "rockband-keyboard-gui-linux-x64.zip"
}

window.updater = updater = new Updater(updaterOptions)

updater.on "download-started", ->

updater.on "download-failed", (err) ->
  console.log err
updater.on "download-finished", ->

updater.on "update-installed", ->
  alert "A new Update was installed!
    Please finish your work and restart this application!
     (Also we shouldn't be that intrusive.)"

await updater.isUpdateAvailable defer err, av

updater.installUpdate() if av && !updater.isInDev()
