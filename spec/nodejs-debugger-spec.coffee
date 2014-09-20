{WorkspaceView} = require 'atom'
NodejsDebugger = require '../lib/nodejs-debugger'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "NodejsDebugger", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('nodejs-debugger')

  describe "when the nodejs-debugger:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.nodejs-debugger')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'nodejs-debugger:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.nodejs-debugger')).toExist()
        atom.workspaceView.trigger 'nodejs-debugger:toggle'
        expect(atom.workspaceView.find('.nodejs-debugger')).not.toExist()
