class AnnotationLifecycle

  _this = undefined

  constructor: ->
    _this = this
    this.annotationDocumentManager = undefined
    this.templates = {}
    this.interfaceInstances = {}

    $(document).ready ->
      _this.init()
      console.log 'AnnotationLifecycle: inited'
      _this.startIteration()

    unless $._data(window, 'events')['popstate']
      $(window).on 'popstate', ->
        documentId = history.state.annotationDocumentId if history.state
        if history.state && documentId && typeof(documentId) == 'number'
          _this.restartIteration documentId
        else
          location.reload()

  init: ->
    dalphiBaseUrl = $('.interfaces-staging').data('dalphi-base-url')
    projectId = $('.interfaces-staging').data('project-id')
    this.annotationDocumentManager = new window.AnnotationDocumentManager(dalphiBaseUrl, projectId)

    $.each($('.template', '.interfaces-staging'), (index, template) ->
      interfaceType = $(template).data('interface-type')
      _this.templates[interfaceType] = template
      # $(this).remove()
    )

  startIteration: ->
    console.log 'AnnotationLifecycle: start new iteration & clean DOM container'
    this.annotationDocumentManager.requestNextDocumentPayload(this.processAnnotationDocument)

  restartIteration: ->
    console.log 'AnnotationLifecycle: restart iteration & clean DOM container'
    this.annotationDocumentManager.requestPreviousDocumentPayload(this.processAnnotationDocument)

  processAnnotationDocument: (data) ->
    unless data
      alert('No annotation document payload available!')
      return

    $('.interfaces-staging > div:not(.template)').remove()
    console.log 'AnnotationLifecycle: process next document payload and render template'

    for interfaceType, payload of data
      template = _this.templates[interfaceType]
      interfaceInstance = _this.interfaceInstances[interfaceType]
      interfaceInstance.iterate(template, payload)
      break

  registerInterfaceInstance: (typeName, instance) ->
    console.log "AnnotationLifecycle: registering interface: #{typeName}"
    this.interfaceInstances[typeName] = instance

  saveChanges: (data) ->
    console.log 'AnnotationLifecycle: save changes in payload using the annotation document manager'

    nextIteration = ->
      _this.startIteration()

    this.annotationDocumentManager.saveDocumentPayload(data, nextIteration)

  skip: ->
    console.log 'AnnotationLifecycle: skip current document'

    nextIteration = ->
      _this.startIteration()

    this.annotationDocumentManager.skipDocument(nextIteration)

window.AnnotationLifecycle = AnnotationLifecycle
