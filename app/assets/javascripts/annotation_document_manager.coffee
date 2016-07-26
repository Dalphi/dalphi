class AnnotationDocumentManager

  _this = undefined

  constructor: (dalphiBaseUrl, projectId, synchronousAjax = false) ->
    _this = this
    this.dalphiBaseUrl = dalphiBaseUrl
    this.projectId = projectId
    this.documentStore = []
    this.currentDocument = undefined
    this.maxAnnotationDocumentsToLoad = 1
    this.apiVersion = 'v1'
    this.asynchronousAjax = !synchronousAjax

    this.initAjax()
    this.loadAnnotationDocuments()

  # external API:

  requestNextDocumentPayload: (calleeCallback) ->
    unless this.currentDocument
      nextDocument = this.next()
      calleeCallback(nextDocument) if nextDocument
      this.loadAnnotationDocuments calleeCallback unless nextDocument
      return true
    false

  saveDocumentPayload: (modifiedPayload, calleeCallback = false) ->
    annotationDocument = this.currentDocument
    annotationDocument.payload = modifiedPayload
    baseUrl = "#{this.dalphiBaseUrl}/api/#{this.apiVersion}"

    requestOptions = {
      type: 'PATCH',
      url: "#{baseUrl}/annotation_documents/#{annotationDocument.id}",
      data: { annotation_document: annotationDocument }
    }

    this.apiCall requestOptions, calleeCallback
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

  apiCall: (requestOptions, responseProcessor = false, postUpdateCallback = false) ->
    $.ajax
      type: requestOptions.type,
      url: requestOptions.url,
      dataType: 'json',
      data: requestOptions.data,
      async: _this.asynchronousAjax,
      success: (data) ->
        responseProcessor(data) if responseProcessor
        postUpdateCallback _this.next() if postUpdateCallback
      error: (a, b, c) ->
        console.log "error requesting the annotation documents API " +
                    "(#{b} #{a.status}; #{c}) - request options & jqXHR:"
        console.log JSON.stringify(requestOptions)
        console.log JSON.stringify(a)

window.AnnotationDocumentManager = AnnotationDocumentManager
