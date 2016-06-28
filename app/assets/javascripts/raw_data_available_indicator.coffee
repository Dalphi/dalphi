class RawDataAvailableIndicator

  _this = undefined

  constructor: ->
    _this = this
    _this.$rawData = $('.raw-data-availability-details')
    _this.url = _this.$rawData.data('url')

    this.initAjax()
    this.checkAvailabilityOfRawData()

  initAjax: ->
    $.ajaxSetup
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  checkAvailabilityOfRawData: ->
    $.ajax
      type: 'GET',
      url: _this.url,
      dataType: 'json'
      beforeSend: ->
        _this.changeState(1)
      success: (data) ->
        _this.handleAjaxResponse(data)
      error: ->
        _this.changeState(3)

  handleAjaxResponse: (data) ->
    if data.length
      _this.changeState(0)
    else
      _this.changeState(2)

  changeState: (stateIndex) ->
    $hint = $('small', $('.raw-data-availability-details').parent())
    if stateIndex == 2
      $hint.removeClass('no-display')
    else
      $hint.addClass('no-display')
    $('.raw-data-state-sign', _this.$rawData).each (index, element) ->
      if index == stateIndex
        $(element).removeClass('no-display')
      else
        $(element).addClass('no-display')

window.RawDataAvailableIndicator = RawDataAvailableIndicator
