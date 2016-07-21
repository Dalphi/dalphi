class AnnotationDocumentManager

  _this = undefined

  constructor: (dalphiUrl, projectId, synchronousAjax = false) ->
    _this = this
    this.dalphiBaseUrl = dalphiUrl
    this.projectId = projectId
    this.documentStore = []
    this.currentDocument = undefined
    this.maxAnnotationDocumentsToLoad = 1
    this.asynchronousAjax = !synchronousAjax

    this.initAjax()
    this.loadAnnotationDocuments()

  requestNextDocumentPayload: (calleeCallback) ->
    unless this.currentDocument
      nextDocument = this.next()
      calleeCallback(nextDocument) if nextDocument
      this.loadAnnotationDocuments calleeCallback unless nextDocument
      return true
    false

  save: (modifiedPayload) ->
    annotationDocument = this.currentDocument
    annotationDocument.payload = modifiedPayload

    requestOptions = {
      type: 'PATCH',
      url: "#{this.dalphiBaseUrl}/annotation_documents/#{annotationDocument.id}",
      data: JSON.stringify(annotationDocument)
    }

    this.apiCall requestOptions
    this.currentDocument = undefined

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

    responseProcessor = (data) ->
      _this.documentStore.push annotationDocument for annotationDocument in data
    this.apiCall requestOptions, responseProcessor, postUpdateCallback

  next: ->
    if this.documentStore.length > 0
      this.currentDocument = this.documentStore.shift()
      return this.currentDocument.payload
    false

  apiCall: (requestOptions, responseProcessor, postUpdateCallback) ->
    $.ajax
      type: requestOptions.type,
      url: requestOptions.url,
      dataType: 'json',
      data: requestOptions.data,
      async: _this.asynchronousAjax,
      success: (data) ->
        responseProcessor(data)
        postUpdateCallback _this.next() if postUpdateCallback
      error: (a, b, c) ->
        console.log "error requesting the next annotation documents (#{b}; #{c}) - request options:"
        console.log requestOptions

window.AnnotationDocumentManager = AnnotationDocumentManager
