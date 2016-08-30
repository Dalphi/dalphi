class AnnotationIteration

  _this = undefined

  constructor: ->
    _this = this
    this.register(@constructor.name, this)

  # external API:

  register: (type, object) ->
    window.annotationLifecycle.registerInterfaceInstance(type, object)

  render: (template, data) ->
    @currentData = data
    mustacheParsedTemplate = Mustache.render(
      template.outerHTML,
      data
    )
    $output = $(mustacheParsedTemplate).removeClass('template')
    $('.interfaces-staging').append($output)

  saveChanges: (data) ->
    window.annotationLifecycle.saveChanges(data)

  skip: ->
    window.annotationLifecycle.skip()

window.AnnotationIteration = AnnotationIteration
