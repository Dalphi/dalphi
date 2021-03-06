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
    this.historyRequest = false
    this.latestSeenDocumentId = 0
    this.errorObjects = {
      404: { code: 404, description: 'no documents left' }
    }

    this.initAjax()
    this.initialAnnotationDocumentPreloading()

  # external API:

  requestNextDocumentPayload: (calleeCallback) ->
    this.handleHistoryLegacy()

    if this.waitingForApi
      # hook into a running request if one is being processed right now
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

  requestPreviousDocumentPayload: (calleeCallback) ->
    this.historyRequest = true

    # put the rendered, but not annotated document back in the queue
    _this.documentStore.unshift _this.currentDocument

    # get a new document id from the history state & load it
    _this.loadAnnotationDocumentWithId(history.state.annotationDocumentId, calleeCallback)

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

  initialAnnotationDocumentPreloading: ->
    documentId = $('.interfaces-staging').data('annotation-document-id')
    documentId = this.documentIdFromUrl() unless documentId
    this.loadAnnotationDocumentWithId(documentId) if documentId
    this.loadAnnotationDocuments() unless documentId

  loadAnnotationDocuments: (postUpdateCallback) ->
    requestOptions = {
      type: 'PATCH',
      dataType: 'json',
      url: "#{this.dalphiBaseUrl}/projects/#{_this.projectId}/annotation_documents/next",
      data: {
        count: _this.maxAnnotationDocumentsToLoad
      }
    }

    responseProcessor = (data) ->
      console.log "AnnotationDocumentManager: loaded new annotation document (id: #{data[0].id})"
      _this.documentStore.push annotationDocument for annotationDocument in data
      _this.waitingForApi = false

    this.waitingForApi = true
    this.apiCall requestOptions, responseProcessor, postUpdateCallback

  loadAnnotationDocumentWithId: (annotationDocumentId, postUpdateCallback) ->
    baseUrl = "#{this.dalphiBaseUrl}/api/#{this.apiVersion}"
    requestOptions = {
      type: 'GET',
      dataType: 'json',
      url: "#{baseUrl}/annotation_documents/#{annotationDocumentId}"
    }

    this.waitingForApi = true
    responseProcessor = (annotationDocument) ->
      console.log "AnnotationDocumentManager: loaded known annotation document (history request)"
      _this.documentStore.unshift annotationDocument
      _this.waitingForApi = false
    this.apiCall requestOptions, responseProcessor, postUpdateCallback

  patchCurrentDocument: (postUpdateCallback) ->
    baseUrl = "#{this.dalphiBaseUrl}/api/#{this.apiVersion}"
    payloadToSend = { annotation_document: this.currentDocument }

    requestOptions = {
      type: 'PATCH',
      dataType: 'text',
      url: "#{baseUrl}/annotation_documents/#{this.currentDocument.id}",
      data: JSON.stringify(payloadToSend)
    }

    this.apiCall requestOptions, postUpdateCallback
    this.currentDocument = undefined

  next: ->
    if this.documentStore.length > 0
      this.currentDocument = this.documentStore.shift()

      nextPayload = {}
      nextPayload[this.currentDocument.interface_type] = this.currentDocument.payload

      unless this.historyRequest
        this.latestSeenDocumentId = this.currentDocument.id
        this.rewriteHistory()

      return nextPayload
    false

  apiCall: (requestOptions, responseProcessor = false, postUpdateCallback = false) ->
    $.ajax
      url: requestOptions.url,
      type: requestOptions.type,
      dataType: requestOptions.dataType,
      contentType: 'application/json',
      data: JSON.stringify(requestOptions.data),
      async: _this.asynchronousRequest,

      success: (data) ->
        responseProcessor(data) if responseProcessor
        _this.generalResponseHandlingWithObject(postUpdateCallback, _this.next())

      error: (a, b, c) ->
        if a.status == 404
          # all annotation documents are annotated; nothing to do
          _this.generalResponseHandlingWithObject(postUpdateCallback, _this.errorObjects[404])

        else
          # an unexpected error occured
          console.log 'error requesting the annotation documents API',
                      "(#{b} #{a.status}; #{c}) - request options & jqXHR:",
                      JSON.stringify(requestOptions),
                      JSON.stringify(a)

  generalResponseHandlingWithObject: (postUpdateCallback, responseObject) ->
    if this.requestNextDocumentCallback
      this.requestNextDocumentCallback responseObject
      this.requestNextDocumentCallback = undefined
    else if postUpdateCallback
      postUpdateCallback responseObject

  handleHistoryLegacy: ->
    if this.historyRequest && this.latestSeenDocumentId > 0
      idList = (item.id for item in this.documentStore)
      for documentId in idList
        break if documentId == this.latestSeenDocumentId
        this.documentStore.shift()

    this.historyRequest = false

  documentIdFromUrl: ->
    regexSearchGroup = /.*\/annotate\/([0-9]+)\D*/.exec(document.location.pathname)
    return undefined unless regexSearchGroup
    regexSearchGroup[1]

  rewriteHistory: ->
    replacement = "annotate/#{this.currentDocument.id}"
    newLocationPath = document.location.pathname.replace(/annotate(\/[0-9]+)?/, replacement)

    window.history.pushState { annotationDocumentId: this.currentDocument.id },
                             document.title,
                             newLocationPath + document.location.search

window.AnnotationDocumentManager = AnnotationDocumentManager
