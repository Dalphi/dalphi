class ServiceAvailableIndicator

  _this = undefined

  constructor: ->
    _this = this
    this.spinnerSettings = {
      corners: 0,
      direction: 1,
      left: '.35rem',
      length: 3,
      lines: 7,
      opacity: 0.15,
      radius: 2,
      rotate: 0,
      scale: 0.05,
      shadow: false,
      speed: 0.9,
      top: '.48rem',
      trail: 68,
      width: 2,
      zIndex: 0
    }
    this.services = []
    this.serviceListItems = $('.connection-details')
    this.noDisplayClass = 'no-display'
    this.availableClass = 'available'
    this.checkingClass = 'checking'
    this.downClass = 'down'
    this.undefinedClass = 'undefined'

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
      # _this.showSpinnerAtService(service, true)
      _this.checkConnectivityForService service

  changeState: (service, stateIndex) ->
    service.container.forEach ($container, index) ->
      if index == stateIndex
        $container.removeClass('no-display')
      else
        $container.addClass('no-display')

      _this.showSpinnerAtService(service, true) if stateIndex == 1
      _this.showSpinnerAtService(service, false) unless stateIndex == 1

  showSpinnerAtService: (service, show) ->
    if show
      service.container[1].spin(this.spinnerSettings)
    else
      service.container[1].spin(false)

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
