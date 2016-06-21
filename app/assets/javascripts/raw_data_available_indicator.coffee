class RawDataAvailableIndicator

  _this = undefined

  constructor: ->
    _this = this
    this.rawData = []

    this.initAjax()
    this.checkAvailabilityOfRawData()
    # this.initServiceList()
    # this.checkConnectivityForAllServices()

  initAjax: ->
    $.ajaxSetup
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  checkAvailabilityOfRawData: ->
    $.ajax
      type: 'GET',
      url: service.url,
      dataType: 'json'
      beforeSend: ->
        _this.changeState(service, 1)
      success: (data) ->
        _this.handleAjaxResponse(service, data)
      error: ->
        _this.changeState(service, 3)


  changeState: (stateIndex) ->
    return true

window.RawDataAvailableIndicator = RawDataAvailableIndicator
