gui = require('nw.gui')
win = gui.Window.get()

win.resizeTo(300, 150)
win.setResizable(false)
win.title = "Updating Rockband Keyboard"

installing = true

win.on("progress", (state) ->
  $("#progress").width(state.percent + "%")
)

win.on("message", (message) ->
  $("#message").text(message)# = message
)

win.on("download-finished", ->
  $("#message").text("Download Finished, installing...")
  $("#progress").width("100%")
)

win.on("update-installed", ->
  installing = false
  alert "A new Update was installed!
    Please finish your work and restart this application!
     (Also we shouldn't be that intrusive.)"
  win.close()
)

win.on('close', ->
  unless installing
    win.close(true)
)
