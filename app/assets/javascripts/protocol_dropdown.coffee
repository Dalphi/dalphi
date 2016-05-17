class ProtocolDropdown

  _this = undefined

  constructor: ->
    _this = this
    this.$protocolFormValue = $('[name="protocol"]')
    this.$protocolDropdownToggle = $('#protocolDropdownToggle')
    this.$toggleButton = $('button', this.$protocolDropdownToggle.parent().parent())

    $('#protocolDropdownToggle').on 'click', (e) ->
      e.preventDefault()
      $this = $(this)
      if $this.text() == 'https://'
        _this.selectProtocol('https')
      else if $this.text() == 'http://'
        _this.selectProtocol('http')

    $('[name="uri"]').on 'change textInput input', ->
      uri = $(this).val()
      if uri.startsWith('https://')
        _this.selectProtocol('https')
        uri = uri.replace('https://', '')
      else if uri.startsWith('http://')
        _this.selectProtocol('http')
        uri = uri.replace('http://', '')
      $(this).val(uri)

  selectProtocol: (protocol) ->
    this.$protocolFormValue.val(protocol)
    this.$toggleButton.text(protocol + '://')
    if protocol == 'https'
      this.$protocolDropdownToggle.text('http://')
    else if protocol == 'http'
      this.$protocolDropdownToggle.text('https://')

window.ProtocolDropdown = ProtocolDropdown
