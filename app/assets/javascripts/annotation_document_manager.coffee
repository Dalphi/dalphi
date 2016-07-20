class AnnotationDocumentManager

  _this = undefined

  constructor: (dalphiUrl, projectId, synchronousAjax) ->
    _this = this
    this.dalphiBaseUrl = dalphiUrl
    this.projectId = projectId
    this.documentStore = []
    this.currentDocument = undefined
    this.asynchronousAjax = true
    this.asynchronousAjax = false if synchronousAjax
    this.initAjax()
    this.loadAnnotationDocuments()

  initAjax: ->
    $.ajaxSetup
      headers:
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

  loadAnnotationDocuments: (postUpdateCallback) ->
    requestOptions = {
      type: 'PATCH',
      url: "#{this.dalphiBaseUrl}/annotation_documents/next"
    }

    responseProcessor = (data) ->
      _this.documentStore.push annotationDocument for annotationDocument in data
    this.apiCall requestOptions, responseProcessor, postUpdateCallback

  requestNextDocumentPayload: (calleeCallback) ->
    unless this.currentDocument
      nextDocument = this.next()
      calleeCallback(nextDocument) if nextDocument
      this.loadAnnotationDocuments calleeCallback unless nextDocument
      return true
    false

  next: ->
    if this.documentStore.length > 0
      this.currentDocument = this.documentStore.shift()
      return this.currentDocument.payload
    false

  count: ->
    this.documentStore.length

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

  apiCall: (requestOptions, responseProcessor, postUpdateCallback) ->
    $.ajax
      type: requestOptions.type,
      url: requestOptions.url,
      dataType: 'json',
      data: { project_id: _this.projectId },
      async: _this.asynchronousAjax,
      success: (data) ->
        responseProcessor(data)
        postUpdateCallback _this.next() if postUpdateCallback
      error: (a, b, c) ->
        console.log "error requesting the next annotation documents (#{b}; #{c}) - request options:"
        console.log requestOptions

window.AnnotationDocumentManager = AnnotationDocumentManager
