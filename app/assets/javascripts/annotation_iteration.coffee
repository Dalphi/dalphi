class AnnotationIteration

  _this = undefined

  constructor: ->
    _this = this
    this.register(@constructor.name, this)

  # external API:

  register: (type, object) ->
    console.log 'AnnotationIteration register'
    window.annotationLifecycle.registerInterfaceInstance(type, object)

  iterate: (template, data) ->
    $('.interfaces-staging > div:not(.template)').remove()
    @currentData = data
    mustacheParsedTemplate = Mustache.render(
      template.outerHTML,
      data
    )
    $output = $(mustacheParsedTemplate).removeClass('template')
    $('.interfaces-staging').append($output)

  saveChanges: (data) ->
    window.annotationLifecycle.saveChanges(data)

window.AnnotationIteration = AnnotationIteration
