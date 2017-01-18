class ClickableTableRow
  constructor: ->
    $('table tr[data-href] td:not(.controls)').on 'click', ->
      Turbolinks.visit($(this).parent().attr('data-href'))

window.ClickableTableRow = ClickableTableRow
