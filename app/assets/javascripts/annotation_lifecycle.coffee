class AnnotationLifecycle

  _this = undefined

  constructor: ->
    _this = this
    this.annotationDocumentManager = undefined
    this.templates = {}
    this.interfaceInstances = {}

    $(document).ready ->
      _this.init()
      console.log 'inited AnnotationLifecycle'
      _this.startIteration()

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
    console.log 'AnnotationLifecycle: start iteration'

    processAnnotationDocument = (data) ->
      unless data
        alert('No annotation document payload available!')
        return

      interfaceInstance = _this.interfaceInstances[data.interfaceType]
      template = _this.templates[data.interfaceType]
      interfaceInstance.iterate(template, data.payload)

    this.annotationDocumentManager.requestNextDocumentPayload(processAnnotationDocument)

  registerInterfaceInstance: (typeName, instance) ->
    console.log "registering interface: #{typeName}"
    this.interfaceInstances[typeName] = instance

  saveChanges: (data) ->
    console.log 'save changes via ann doc manager'  # call ann doc manager

    nextIteration = ->
      _this.startIteration()

    this.annotationDocumentManager.saveDocumentPayload(data, nextIteration)

window.AnnotationLifecycle = AnnotationLifecycle
