class AnnotationDocumentManager

  _this = undefined

  constructor: (dalphiUrl) ->
    _this = this
    this.dalphiBaseUrl = dalphiUrl
    this.documentStore = []
    this.currentDocument = undefined
    this.loadAnnotationDocuments()

  loadAnnotationDocuments: (postUpdateCallback) ->
    requestOptions = {
      type: 'PATCH',
      url: "#{this.dalphiBaseUrl}/annotation_documents/next"
    }

    responseProcessor = (data) ->
      for annotationDocument of data
        this.documentStore.push(annotationDocument)

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
      dataType: 'json'
      success: (data) ->
        responseProcessor(data)
        postUpdateCallback _this.next() if postUpdateCallback
      error: ->
        console.log 'error requesting the next annotation documents - request options:'
        console.log requestOptions

window.AnnotationDocumentManager = AnnotationDocumentManager
