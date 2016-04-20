class NavigationHandler

  _this = undefined

  constructor: ->
    _this = this
    this.$topbar = $('.topbar')
    this.$sidebar = $('.sidebar')
    body = $('body')[0]

    $('.toggle-sidebar, .dark-curtain').click (event) ->
      event.preventDefault()
      _this.toggleSidebar()

    Hammer(body).on 'swipeleft', ->
      _this.relaxSidebar()

    Hammer(body).on 'swiperight', ->
      _this.expandSidebar()

  expandSidebar: ->
    this.$sidebar.addClass('expanded')
    this.$topbar.addClass('expanded')

  relaxSidebar: ->
    this.$sidebar.removeClass('expanded')
    this.$topbar.removeClass('expanded')

  toggleSidebar: ->
    this.$sidebar.toggleClass('expanded')
    this.$topbar.toggleClass('expanded')

window.NavigationHandler = NavigationHandler
