gui = require('nw.gui')
win = gui.Window.get()

win.on("progress", (state) ->
  #document.getElementById("progress").value = ""+state.progress
)

win.on("message", (message) ->
  document.getElementById("message").innerHtml = message
  alert(message)
)
