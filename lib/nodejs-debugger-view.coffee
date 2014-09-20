{View} = require 'atom'

module.exports =
class NodejsDebuggerView extends View
  @content: ->
    @div class: 'witness', =>
      @div "ON", class: "active"

  initialize: (serializeState) ->
    atom.workspaceView.command "nodejs-debugger:toggle", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "NodejsDebuggerView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
