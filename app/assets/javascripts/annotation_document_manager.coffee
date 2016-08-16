class AnnotationDocumentManager

  _this = undefined

  constructor: (dalphiBaseUrl, projectId, synchronousRequest = false) ->
    _this = this
    this.dalphiBaseUrl = dalphiBaseUrl
    this.projectId = projectId
    this.documentStore = []
    this.currentDocument = undefined
    this.maxAnnotationDocumentsToLoad = 1
    this.apiVersion = 'v1'
    this.asynchronousRequest = !synchronousRequest
    this.waitingForApi = false
    this.requestNextDocumentCallback = undefined

    this.initAjax()
    this.loadAnnotationDocuments()

  # external API:

  requestNextDocumentPayload: (calleeCallback) ->
    if this.waitingForApi
      # hook into a running request if one if being processed right now
      _this.requestNextDocumentCallback = calleeCallback
      return true

    else unless this.currentDocument
      # no annotation document is currently being processed
      nextDocument = this.next()

      # an annotation document is already preloaded
      calleeCallback(nextDocument) if nextDocument

      # request a new annotation document if none was preloaded
      this.loadAnnotationDocuments calleeCallback unless nextDocument
      return true
    false

  saveDocumentPayload: (modifiedPayload, calleeCallback = false) ->
    this.currentDocument.payload = modifiedPayload
    this.currentDocument.skipped = false
    this.patchCurrentDocument(calleeCallback)

  skipDocument: (calleeCallback = false) ->
    this.currentDocument.skipped = true
    this.patchCurrentDocument(calleeCallback)

  # internal API:

  initAjax: ->
    $.ajaxSetup
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  loadAnnotationDocuments: (postUpdateCallback) ->
    requestOptions = {
      type: 'PATCH',
      url: "#{this.dalphiBaseUrl}/annotation_documents/next",
      data: {
        project_id: _this.projectId,
        count: _this.maxAnnotationDocumentsToLoad
      }
    }

    this.waitingForApi = true
    responseProcessor = (data) ->
      console.log "AnnotationDocumentManager: loaded new annotation document (id: #{data[0].id})"
      _this.documentStore.push annotationDocument for annotationDocument in data
      _this.waitingForApi = false
    this.apiCall requestOptions, responseProcessor, postUpdateCallback

  patchCurrentDocument: (postUpdateCallback) ->
    baseUrl = "#{this.dalphiBaseUrl}/api/#{this.apiVersion}"

    requestOptions = {
      type: 'PATCH',
      url: "#{baseUrl}/annotation_documents/#{this.currentDocument.id}",
      data: { annotation_document: this.currentDocument }
    }

    this.apiCall requestOptions, postUpdateCallback
    this.currentDocument = undefined

  next: ->
    if this.documentStore.length > 0
      this.currentDocument = this.documentStore.shift()

      nextPayload = {}
      nextPayload[this.currentDocument.interface_type] = this.currentDocument.payload

      return nextPayload
    false

  apiCall: (requestOptions, responseProcessor = false, postUpdateCallback = false) ->
    $.ajax
      type: requestOptions.type,
      url: requestOptions.url,
      dataType: 'json',
      data: requestOptions.data,
      async: _this.asynchronousRequest,
      success: (data) ->
        responseProcessor(data) if responseProcessor
        if _this.requestNextDocumentCallback
          _this.requestNextDocumentCallback _this.next()
          _this.requestNextDocumentCallback = undefined
        else if postUpdateCallback
          postUpdateCallback _this.next()
      error: (a, b, c) ->
        console.log "error requesting the annotation documents API " +
                    "(#{b} #{a.status}; #{c}) - request options & jqXHR:"
        console.log JSON.stringify(requestOptions)
        console.log JSON.stringify(a)

window.AnnotationDocumentManager = AnnotationDocumentManager
