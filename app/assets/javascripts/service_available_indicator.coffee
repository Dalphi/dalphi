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

    # test the spinner
    this.showSpinnerAtSeviceWithIndex(1, true)

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

  showSpinnerAtSeviceWithIndex: (serviceIndex, show) ->
    if show
      this.services[serviceIndex].icon.css('visibility', 'hidden')
      this.services[serviceIndex].element.addClass('checking')
      this.services[serviceIndex].element.spin(this.spinnerSettings)
    else
      this.services[serviceIndex].icon.css('visibility', 'visible')
      this.services[serviceIndex].element.removeClass('checking')
      this.services[serviceIndex].element.spin(false)

  # performAjaxRequest: (data, changeCheckboxesState) ->
  #   $.ajax
  #     type: 'PATCH',
  #     url: this.ajaxPath,
  #     dataType: 'json'
  #     data: data,
  #     beforeSend: ->
  #       showSpinnerAtTableHead(true)
  #     success: ->
  #       console.log 'successfully posted data via ajax'
  #     error: ->
  #       console.log 'faild to post data via ajax'
  #     complete: ->
  #       if changeCheckboxesState
  #         enableVisibleCheckboxes(changeCheckboxesState)
  #       showSpinnerAtTableHead(false)

window.ServiceAvailableIndicator = ServiceAvailableIndicator
