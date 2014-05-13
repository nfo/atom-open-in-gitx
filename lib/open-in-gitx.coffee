exec = require("child_process").exec

module.exports =
  activate: (state) ->
    atom.workspaceView.command "open-in-gitx:open", => @openApp()

  openApp: ->
    path = atom.project?.getPath()
    exec "open -a GitX.app #{path}" if path?
