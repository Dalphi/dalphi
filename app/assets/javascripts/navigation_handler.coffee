class NavigationHandler

  _this = undefined

  constructor: ->
    _this = this
    this.$topbar = $('.topbar')
    this.$navbar = $('.navbar-nav')
    this.$sidebar = $('.sidebar')
    this.hideClassName = 'hidden-sm-down'
    this.sidebarExpandedClassName = 'sidebar-expanded'
    this.sidebarNotExpandedButtonClassName = 'sidebar-not-expanded'

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
    if !this.mobileStyle
      this.$sidebar.addClass(_this.hideClassName)

  toggleSidebar: ->
    this.$sidebar.toggleClass(this.hideClassName)
    this.$navbar.toggleClass(this.sidebarExpandedClassName)
    this.$navbar.toggleClass(this.sidebarNotExpandedButtonClassName)

window.NavigationHandler = NavigationHandler
