# Play Audio

FileIO = require "../os/file-io"
Model = require "model"

module.exports = ->
  # Global system
  {ContextMenu, MenuBar, Modal, Observable, Progress, Util:{parseMenu}, Window} = system.UI
  {Achievement} = system

  Achievement.unlock "Pump up the jam"

  audio = document.createElement 'audio'
  audio.controls = true
  audio.autoplay = true

  filePath = Observable()

  handlers = Model().include(FileIO).extend
    loadFile: (blob) ->
      filePath blob.path
      audio.src = URL.createObjectURL blob

    exit: ->
      windowView.element.remove()

  menuBar = MenuBar
    items: parseMenu """
      [F]ile
        [O]pen
        -
        E[x]it
    """
    handlers: handlers

  windowView = Window
    title: ->
      if path = filePath()
        "Audio Bro - #{path}"
      else
        "Audio Bro"
    content: audio
    menuBar: menuBar.element
    width: 308
    height: 80
    iconEmoji: "🎶"

  windowView.send = (type, method, args...) ->
    if type is "application"
      handlers[method](args...)
    else
      console.warn "Don't know how to handle #{type}, #{method}", args

  return windowView
