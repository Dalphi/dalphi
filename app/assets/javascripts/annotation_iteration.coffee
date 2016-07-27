class AnnotationIteration

  _this = undefined

  constructor: ->
    _this = this
    this.register(@constructor.name, this)

  # external API:

  register: (type, object) ->
    window.annotationLifecycle.registerInterfaceInstance(type, object)

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
