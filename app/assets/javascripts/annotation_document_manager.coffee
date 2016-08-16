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

    this.initAjax()
    this.initialAnnotationDocumentPreloading()

  # external API:

  requestNextDocumentPayload: (calleeCallback) ->
    this.historyRequest = false

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
    documentId = this.documentIdFromUrl()
    this.loadAnnotationDocumentWithId(documentId) if documentId
    this.loadAnnotationDocuments() unless documentId

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

  loadAnnotationDocumentWithId: (annotationDocumentId, postUpdateCallback) ->
    baseUrl = "#{this.dalphiBaseUrl}/api/#{this.apiVersion}"
    requestOptions = {
      type: 'GET',
      url: "#{baseUrl}/annotation_documents/#{annotationDocumentId}"
    }

    this.waitingForApi = true
    responseProcessor = (annotationDocument) ->
      console.log "AnnotationDocumentManager: loaded concrete annotation document (id: #{annotationDocument.id}, history request)"
      _this.documentStore.unshift annotationDocument
      _this.waitingForApi = false
    this.apiCall requestOptions, responseProcessor, postUpdateCallback

  next: ->
    if this.documentStore.length > 0
      this.currentDocument = this.documentStore.shift()

      nextPayload = {}
      nextPayload[this.currentDocument.interface_type] = this.currentDocument.payload

      this.rewriteHistory() unless this.historyRequest
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

  documentIdFromUrl: ->
    searchString = document.location.search
    index = searchString.search(/documentId=[0-9]+/)
    return undefined if index < 0

    index += + 'documentId='.length
    endPosition = searchString.indexOf('&', index)
    searchString.substring(index, endPosition) if endPosition > 0
    searchString.substring index if endPosition < 0

  rewriteHistory: ->
    # get the last, through history changeable part of the current url
    pathnameArray = document.location.pathname.split '/'
    lastPathElement = pathnameArray[pathnameArray.length - 1]

    # get the search string (GET arguments) and change the current document id
    currentSearchString = document.location.search
    documentArgument = "documentId=#{this.currentDocument.id}"
    if currentSearchString.indexOf('documentId') > 0
      newSearchString = currentSearchString.replace(/documentId=[0-9]+/, documentArgument)
    else
      newSearchString = "#{currentSearchString}&#{documentArgument}" if currentSearchString
      newSearchString = "?#{documentArgument}" unless currentSearchString

    window.history.pushState { annotationDocumentId: this.currentDocument.id },
                             document.title,
                             "#{lastPathElement}#{newSearchString}"

window.AnnotationDocumentManager = AnnotationDocumentManager
