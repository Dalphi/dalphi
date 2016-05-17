class ProtocolDropdown
  constructor: ->
    $('#protocolDropdownToggle').on 'click', (e) ->
      e.preventDefault()
      $this = $(this)
      if $this.text() == 'https://'
        selectProtocol('https')
      else if $this.text() == 'http://'
        selectProtocol('http')

    $('[name="uri"]').on 'change textInput input', ->
      uri = $(this).val()
      if uri.startsWith('https://')
        selectProtocol('https')
        uri = uri.replace('https://', '')
      else if uri.startsWith('http://')
        selectProtocol('http')
        uri = uri.replace('http://', '')
      $(this).val(uri)

  selectProtocol = (protocol) ->
    $protocolFormValue = $('[name="protocol"]')
    $protocolDropdownToggle = $('#protocolDropdownToggle')
    $toggleButton = $('button', $protocolDropdownToggle.parent().parent())

    $protocolFormValue.val(protocol)
    $toggleButton.text(protocol + '://')
    if protocol == 'https'
      $protocolDropdownToggle.text('http://')
    else if protocol == 'http'
      $protocolDropdownToggle.text('https://')


window.ProtocolDropdown = ProtocolDropdown
