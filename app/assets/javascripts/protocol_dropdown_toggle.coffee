class ProtocolDropdownToggle
  constructor: ->
    $('#protocolDropdownToggle').on 'click', ->
      $this = $(this)
      $toggleButton = $('button', $this.parent().parent())
      newContent = $this.text()
      oldContent = $toggleButton.text()
      $this.text(oldContent)
      $toggleButton.text(newContent)

window.ProtocolDropdownToggle = ProtocolDropdownToggle
