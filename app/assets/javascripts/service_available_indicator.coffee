class ServiceAvailableIndicator

  _this = undefined

  constructor: ->
    _this = this
    this.services = []
    this.serviceListItems = $('.connection-details')

    this.initAjax()
    this.initServiceList()
    this.checkConnectivityForAllServices()

  initServiceList: ->
    this.serviceListItems.each (index, element) ->
      _this.services[index] = {
        url: $(element).data('url'),
        container: [
          $('.available', element),
          $('.checking', element),
          $('.down', element),
          $('.undefined', element)
        ]
      }

  initAjax: ->
    $.ajaxSetup
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  checkConnectivityForAllServices: ->
    this.services.forEach (service) ->
      _this.checkConnectivityForService service

  changeState: (service, stateIndex) ->
    service.container.forEach ($container, index) ->
      if index == stateIndex
        $container.removeClass('no-display')
      else
        $container.addClass('no-display')

  checkConnectivityForService: (service) ->
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

  handleAjaxResponse: (service, response) ->
    if response.serviceIsAvailable
      this.changeState(service, 0)
    else
      this.changeState(service, 2)

window.ServiceAvailableIndicator = ServiceAvailableIndicator
