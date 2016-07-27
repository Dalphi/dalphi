class AnnotationIteration

  _this = undefined

  constructor: ->
    _this = this
    this.register(this)

  # external API:

  register: (object) ->
    window.annotationLifecycle.registerInterfaceInstance(object)

  iterate: (template, data) ->
    $('.interfaces-staging > div:not(.template)').remove()
    $output = $(
      Mustache.render(
        template.outerHtml,
        data
      )
    ).removeClass('template')
    $('.interfaces-staging').append($output)

  saveChanges: (data) ->
    window.annotationLifecycle.saveChanges(data)

window.AnnotationIteration = AnnotationIteration
