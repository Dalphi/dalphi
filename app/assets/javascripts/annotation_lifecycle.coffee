class AnnotationLifecycle

  _this = undefined

  constructor: ->
    _this = this
    # any docs?
    # iterate with

  registerInterfaceInstance: (interfaceInstance) ->
    console.log 'registerInterfaceInstance' # TODO

  saveChanges: (data) ->
    console.log 'save changes via ann doc manager'  # call ann doc manager

window.annotationLifecycle = new AnnotationLifecycle()
