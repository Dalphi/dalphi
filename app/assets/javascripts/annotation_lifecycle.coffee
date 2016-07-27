class AnnotationLifecycle

  _this = undefined

  constructor: ->
    _this = this
    this.annotationDocumentManager = undefined

    this.init()
    console.log 'inited AnnotationLifecycle'
    # any docs?
    # iterate with

  init: ->
    dalphiBaseUrl = $('.interfaces-staging').data('dalphi-base-url')
    projectId = $('.interfaces-staging').data('project-id')
    this.annotationDocumentManager = new window.AnnotationDocumentManager(dalphiBaseUrl, projectId)

  registerInterfaceInstance: (interfaceInstance) ->
    console.log 'registerInterfaceInstance' # TODO

  saveChanges: (data) ->
    console.log 'save changes via ann doc manager'  # call ann doc manager

$(document).ready ->
  window.annotationLifecycle = new AnnotationLifecycle()
