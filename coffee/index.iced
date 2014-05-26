gui = require 'nw.gui'

packageFile = require './package.json'

updateServer = packageFile.remoteUpdateUrl
localVersion = packageFile.version

updaterOptions = {
  localVersion: localVersion
  osxAppName: "Rockband Keyboard"
  updateServer: updateServer
  remoteFilenameOSX: "RockbandKeyboard-osx-ia32.zip"
  remoteFilenameWin: "RockbandKeyboard-win-ia32.zip"
  remoteFilenameLinux32: "RockbandKeyboard-linux-ia32.zip"
  remoteFilenameLinux64: "RockbandKeyboard-linux-x64.zip"
}

window.updater = updater = new Updater(updaterOptions)

updater.on "download-started", ->
  window.updaterWindow = gui.Window.get(
    window.open('./update.html')
  )
updater.on "download-failed", (err) ->
  window.updaterWindow.emit("message", err)
  alert err
updater.on "download-finished", ->
  window.updaterWindow.emit("download-finished")
updater.on "download-progress", (state) ->
  window.updaterWindow.emit("progress", state)
updater.on "update-installed", ->
  window.updaterWindow.emit("update-installed")

await updater.isUpdateAvailable defer err, av

updater.installUpdate() if av && !updater.isInDev()
