class CopyToClipboard

  _this = undefined

  constructor: ->
    _this = this
    this.hideTooltipDelay = 750
    this.clipboard = new Clipboard('.copy-to-clipboard-button')

    # activate tooltips
    $('[data-toggle="tooltip"]').tooltip()

    # hide tooltip after click
    $('.copy-to-clipboard-button').on 'click', ->
      clipboardButton = $(this)
      setTimeout ->
        clipboardButton.tooltip('hide')
      , _this.hideTooltipDelay

window.CopyToClipboard = CopyToClipboard
