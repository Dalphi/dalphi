class NavigationHandler

  _this = undefined

  constructor: ->
    _this = this
    this.$topbar = $('.topbar')
    this.$sidebar = $('.sidebar')

    $('.toggle-sidebar, .dark-curtain').click (event) ->
      event.preventDefault()
      _this.toggleSidebar()

  toggleSidebar: ->
    this.$sidebar.toggleClass('expanded')
    this.$topbar.toggleClass('expanded')

window.NavigationHandler = NavigationHandler
