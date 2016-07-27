class AnnotationIteration

  _this = undefined

  constructor: ->
    _this = this
    this.register(this)

  # external API:

  register: (object) ->
    window.annotationLifecycle.registerInterfaceInstance(object)

  iterate: (data) ->
    console.log 'iterate!' # TODO

  saveChanges: (data) ->
    window.annotationLifecycle.saveChanges(data)

  # internal API:
