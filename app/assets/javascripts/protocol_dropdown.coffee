class ProtocolDropdown
  constructor: ->
    $('#protocolDropdownToggle').on 'click', ->
      $this = $(this)
      $toggleButton = $('button', $this.parent().parent())
      $protocol = $('[name="protocol"]')
      newContent = $this.text()
      oldContent = $toggleButton.text()
      $this.text(oldContent)
      $toggleButton.text(newContent)
      $protocol.val(newContent)

window.ProtocolDropdown = ProtocolDropdown
