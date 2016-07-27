class SelectedInterfaces

  _this = undefined

  constructor: ->
    _this = this

    this.initAjax()
    this.getSelectedInterfaces()

  getSelectedInterfaces: ->
    $.ajax
      type: 'GET',
      url: $('.selected-interfaces').data('href'),
      dataType: 'json'
      beforeSend: ->
        _this.changeState(1)
      success: (data) ->
        _this.handleAjaxResponse(data)
      error: ->
        _this.changeState(4)

  initAjax: ->
    $.ajaxSetup
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  handleAjaxResponse: (data) ->
    selectedInterfaces = data.selectedInterfaces

    if $.isEmptyObject(selectedInterfaces)
      return _this.changeState(3)

    _this.changeState(2)
    $selectedInterfacesList = $('.selected-interfaces .interface-types')
    itemTemplate =
      $('.template', $selectedInterfacesList)
        .clone()
        .removeClass('template')
        .removeClass('no-display')[0]
        .outerHTML
    $('li:not(.template)', $selectedInterfacesList).remove()
    for interfaceType, selectedInterface of data.selectedInterfaces
      displaySelected = if selectedInterface == null then 'no-display' else ''
      displayNotSelected = if selectedInterface == null then '' else 'no-display'
      $selectedInterfacesList.append(
        itemTemplate
          .replace(/interfaceType/g, interfaceType)
          .replace(/displaySelected/g, displaySelected)
          .replace(/displayNotSelected/g, displayNotSelected)
      )
    $('[data-toggle="tooltip"]', $selectedInterfacesList).tooltip()

  changeState: (state) ->
    $('.selected-interfaces .card-text').addClass('no-display')
    $('.selected-interfaces .checking').removeClass('no-display') if state == 1
    $('.selected-interfaces .interface-types').removeClass('no-display') if state == 2
    $('.selected-interfaces .blank-slate').removeClass('no-display') if state == 3
    $('.selected-interfaces .error').removeClass('no-display') if state == 4

window.SelectedInterfaces = SelectedInterfaces
