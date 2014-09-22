NodejsDebuggerView = require './nodejs-debugger-view'
$ = require 'jquery'
_ = require 'lodash'

module.exports =
  nodejsDebuggerView: null
  isActive: false
  currentMarker: null
  $container: null

  clean: ->
    $('.gutter').removeClass('debug-mode')
    $('.breakpoint', @$container).remove() if @$container
    @currentMarker.destroy() if @currentMarker

  init: ->
    core = ->
      editor = atom.workspace.activePaneItem
      $('.gutter').removeClass('debug-mode')
      setTimeout ->
        $('.gutter').addClass('debug-mode')
        @$container = $('.line-number')
        newItems = _.where($('.line-number'), (item) ->
          $('.breakpoint', item).length is 0
        )
        $bb = $('<div class="breakpoint"></div>')
        $bb.click((event) ->
          $bb = $(event.currentTarget)
          parent = $bb.parent()
          classes = _.where(parent.attr('class').split(/\s+/), (item) ->
            pattern = /line-number-[0-9]+/
            pattern.test(item)
          )
          if classes.length is 1
            nb = classes[0].replace("line-number-", "")
            nb = parseInt(nb) + 1
            if $bb.hasClass("active")
              $bb.removeClass("active")
              console.log "remove breakpoint on line: ", nb
            else
              $bb.addClass("active")
              console.log "add breakpoint on line: ", nb
        )
        $(newItems).prepend($bb)
    editor = atom.workspace.activePaneItem
    editor.onDidChangeCursorPosition ->
      core()
    core()

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
