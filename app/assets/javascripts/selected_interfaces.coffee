class SelectedInterfaces

  _this = undefined

  constructor: ->
    _this = this

  ajac: ->
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

  initAjax: ->
    $.ajaxSetup
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

window.SelectedInterfaces = SelectedInterfaces
