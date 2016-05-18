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
    this.serviceListItems = $('.connectivity-sign')

    this.initAjax()
    this.initServiceList()
    this.checkConnectivityForAllServices()

  initServiceList: ->
    this.serviceListItems.each (index, element) ->
      $element = $(element)
      $icon = $($element.children()[0])
      serviceUrl = $element.data('url')

      _this.services[index] = {
        element: $element,
        icon: $icon,
        url: serviceUrl
      }

  initAjax: ->
    $.ajaxSetup
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  checkConnectivityForAllServices: ->
    this.services.forEach (service) ->
      _this.checkConnectivityForService service

  showSpinnerAtService: (service, show) ->
    if show
      service.icon.css('visibility', 'hidden')
      service.element.addClass('checking')
      service.element.spin(this.spinnerSettings)
    else
      service.icon.css('visibility', 'visible')
      service.element.removeClass('checking')
      service.element.spin(false)

  checkConnectivityForService: (service) ->
    $.ajax
      type: 'GET',
      url: service.url,
      dataType: 'json'
      beforeSend: ->
        _this.showSpinnerAtService(service, true)
      success: (data) ->
        _this.handleAjaxResponse(service, data)
      error: ->
        _this.handleAjaxError service
      complete: ->
        _this.showSpinnerAtService(service, false)

  handleAjaxResponse: (service, response) ->
    this.cleanColorClassesFromService service
    if response.serviceIsAvailable
      service.element.addClass('available')
    else
      service.element.addClass('down')

  handleAjaxError: (service) ->
    this.cleanColorClassesFromService service
    service.element.addClass('undefined')

  cleanColorClassesFromService: (service) ->
    service.element.removeClass('available')
    service.element.removeClass('down')
    service.element.removeClass('undefined')

window.ServiceAvailableIndicator = ServiceAvailableIndicator
