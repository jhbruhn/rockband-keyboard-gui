window.updater = updater = new Updater("Rockband Keyboard")

updater.on "download-started", ->
  alert "Download started!"
updater.on "download-failed", (err) ->
  alert "Download Failed"
  console.log err
updater.on "download-finished", ->
  alert "Download finished!"
updater.on "update-installed", ->
  alert "Update installed!"

await updater.is_update_available defer err, av

updater.installUpdate() if av
