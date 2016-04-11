class NavigationHandler

  _this = undefined

  constructor: ->
    _this = this
    this.$topbar = $('.topbar')
    this.$sidebar = $('.sidebar')
    this.hideClassName = 'hidden-sm-down'
    this.largeScreensClassName = 'md-up-screens'

    this.updateDimensions()

    $(window).resize () ->
      _this.updateDimensions()
      _this.handleSizeDependetClasses()

    $('.toggle-sidebar').click (event) ->
      event.preventDefault()
      _this.toggleSidebar()

  updateDimensions: ->
    this.mobileStyle = this.$topbar.css('display') != 'none'

  handleSizeDependetClasses: ->
    if this.mobileStyle
      this.$sidebar.removeClass(_this.largeScreensClassName)
    else
      this.$sidebar.addClass(_this.hideClassName)
      this.$sidebar.addClass(_this.largeScreensClassName)

  toggleSidebar: ->
    if this.$sidebar.hasClass(this.hideClassName)
      this.$sidebar.removeClass(this.hideClassName)
    else
      this.$sidebar.addClass(this.hideClassName)

window.NavigationHandler = NavigationHandler
