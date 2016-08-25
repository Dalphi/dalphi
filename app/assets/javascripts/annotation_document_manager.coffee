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

  initialAnnotationDocumentPreloading: ->
    documentId = $('.interfaces-staging').data('annotation-document-id')
    documentId = this.documentIdFromUrl() unless documentId

    this.loadAnnotationDocumentWithId(documentId) if documentId
    this.loadAnnotationDocuments() unless documentId

  loadAnnotationDocuments: (postUpdateCallback) ->
    requestOptions = {
      type: 'PATCH',
      url: "#{this.dalphiBaseUrl}/projects/#{_this.projectId}/annotation_documents/next",
      data: {
        count: _this.maxAnnotationDocumentsToLoad
      }
    }

    this.waitingForApi = true
    responseProcessor = (data) ->
      console.log "AnnotationDocumentManager: loaded new annotation document (id: #{data[0].id})"
      _this.documentStore.push annotationDocument for annotationDocument in data
      _this.waitingForApi = false
    this.apiCall requestOptions, responseProcessor, postUpdateCallback

  loadAnnotationDocumentWithId: (annotationDocumentId, postUpdateCallback) ->
    baseUrl = "#{this.dalphiBaseUrl}/api/#{this.apiVersion}"
    requestOptions = {
      type: 'GET',
      url: "#{baseUrl}/annotation_documents/#{annotationDocumentId}"
    }

    this.waitingForApi = true
    responseProcessor = (annotationDocument) ->
      console.log "AnnotationDocumentManager: loaded known annotation document (history request)"
      _this.documentStore.unshift annotationDocument
      _this.waitingForApi = false
    this.apiCall requestOptions, responseProcessor, postUpdateCallback

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

  handleHistoryLegacy: ->
    if this.historyRequest && this.latestSeenDocumentId > 0
      numberOfShifts = 0
      for queuedDocument in this.documentStore
        break if queuedDocument && queuedDocument.id == this.latestSeenDocumentId
        numberOfShifts++
      this.documentStore.shift() for x in [1..numberOfShifts] if numberOfShifts > 0

    this.historyRequest = false

  documentIdFromUrl: ->
    pathname = document.location.pathname
    regex = /.*\/annotate\/([0-9]+)\D*/
    result = regex.exec(pathname)
    return result unless result
    result[1]

  rewriteHistory: ->
    replacement = "annotate/#{this.currentDocument.id}"
    newLocationPath = document.location.pathname.replace(/annotate(\/[0-9]+)?/, replacement)
    newLocationPath += document.location.search if document.location.search

    window.history.pushState { annotationDocumentId: this.currentDocument.id },
                             document.title,
                             newLocationPath

window.AnnotationDocumentManager = AnnotationDocumentManager
