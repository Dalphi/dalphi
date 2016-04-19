class ClickableTableRow
  constructor: ->
    $('table tr[data-href] td:not(.controls)').on 'click', ->
      window.location.href = $(this).parent().attr('data-href')

window.ClickableTableRow = ClickableTableRow
