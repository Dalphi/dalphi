class CompatibilityCheckIndicator

  _this = undefined

  constructor: ->
    _this = this
    _this.$compatibilityCheck = $('.compatibility-check-details')
    _this.url = _this.$compatibilityCheck.data('url')

    this.initAjax()
    this.checkCompatibility()

  initAjax: ->
    $.ajaxSetup
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  checkCompatibility: ->
    $.ajax
      type: 'GET',
      url: _this.url,
      dataType: 'json'
      beforeSend: ->
        _this.changeState(1)
      success: (data) ->
        _this.handleAjaxResponse(data)
      error: ->
        _this.changeState(4)

  handleAjaxResponse: (data) ->
    associatedProblemIdentifiers = data['associatedProblemIdentifiers']
    if associatedProblemIdentifiers.length == 1
      _this.changeState(0, associatedProblemIdentifiers)
    else if associatedProblemIdentifiers.length == 0
      _this.changeState(2, associatedProblemIdentifiers)
    else
      _this.changeState(3, associatedProblemIdentifiers)

  changeState: (stateIndex, associatedProblemIdentifiers) ->
    $messageContainer = $('small', $('.compatibility-check-details').parent())
    if stateIndex == 0
      message = $messageContainer
                  .data('compatible')
                  .replace('%problem', associatedProblemIdentifiers[0])
      $('[data-toggle="tooltip"].compatible').attr('data-original-title', message)
      $messageContainer.html('(' + message + ')')
    else if stateIndex == 2
      message = $messageContainer.data('empty')
      $messageContainer.html('(' + message + ')')
    else if stateIndex == 3
      message = $messageContainer
                  .data('incompatible')
                  .replace('%problems', associatedProblemIdentifiers.join(', '))
      $messageContainer.html('(' + message + ')')
    else
      $messageContainer.html('')
    _this.changeIcon(stateIndex)

  changeIcon: (stateIndex) ->
    $('.compatibility-state-sign', _this.$compatibilityCheck).each (index, element) ->
      if index == stateIndex
        $(element).removeClass('no-display')
      else
        $(element).addClass('no-display')

window.CompatibilityCheckIndicator = CompatibilityCheckIndicator
