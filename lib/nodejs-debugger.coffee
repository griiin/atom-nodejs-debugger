NodejsDebuggerView = require './nodejs-debugger-view'

module.exports =
  nodejsDebuggerView: null

  activate: (state) ->
    @nodejsDebuggerView = new NodejsDebuggerView(state.nodejsDebuggerViewState)

  deactivate: ->
    @nodejsDebuggerView.destroy()

  serialize: ->
    nodejsDebuggerViewState: @nodejsDebuggerView.serialize()
