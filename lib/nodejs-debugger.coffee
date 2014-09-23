NodejsDebuggerView = require './nodejs-debugger-view'
$ = require 'jquery'
_ = require 'lodash'

module.exports =
  nodejsDebuggerView: null
  isActive: false

  clean: ->
    $('.gutter').removeClass('debug-mode')
    $('.breakpoint').remove()

  core: ->
    editor = atom.workspace.activePaneItem
    $('.gutter').removeClass('debug-mode')
    setTimeout ->
      $('.gutter').addClass('debug-mode')
      newItems = _.where($('.line-number'), (item) ->
        $('.breakpoint', item).length is 0
      )
      breakpoint = $('<div class="breakpoint"></div>')
      breakpoint.click((event) ->
        breakpoint = $(event.currentTarget)
        parent = breakpoint.parent()
        classes = _.where(parent.attr('class').split(/\s+/), (item) ->
          pattern = /line-number-[0-9]+/
          pattern.test(item)
        )
        if classes.length is 1
          nb = classes[0].replace("line-number-", "")
          nb = parseInt(nb) + 1
          if breakpoint.hasClass("active")
            breakpoint.removeClass("active")
            console.log "remove breakpoint on line: ", nb
          else
            breakpoint.addClass("active")
            console.log "add breakpoint on line: ", nb
      )
      $(newItems).prepend(breakpoint)

  init: ->
    editor = atom.workspace.activePaneItem
    editor.onDidChangeCursorPosition(_.bind(@core, this))
    @core()

  toggle: ->
    if @isActive
      @clean()
    else
      @init()
    @isActive = not @isActive

  activate: (state) ->
    atom.workspaceView.command "nodejs-debugger:toggle", => @toggle()
    @nodejsDebuggerView = new NodejsDebuggerView(state.nodejsDebuggerViewState)
    atom.workspace.onDidChangeActivePaneItem(@init)

  deactivate: ->
    @nodejsDebuggerView.destroy()

  serialize: ->
    nodejsDebuggerViewState: @nodejsDebuggerView.serialize()
