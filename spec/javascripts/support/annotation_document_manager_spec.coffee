#= require annotation_document_manager

beforeAll ->
  Teaspoon.hook('setup')
  Teaspoon.hook('create_annotation_document')

  fixture.preload('parameters.html')
  parameterFixtures = fixture.load('parameters.html', true)

  @dalphiUrl = "#{Teaspoon.location}".match(/http[s]*:\/\/[0-9a-z\.:]+/)[0]
  @projectId = $('.data-container-project-reference', parameterFixtures).data('project-reference')

beforeEach ->
  Teaspoon.hook('create_annotation_document')
  @manager = new window.AnnotationDocumentManager(@dalphiUrl, @projectId, true)

describe 'internal API', ->
  it('should have created a valid manager object', ->
    expect(@manager).toBeDefined()
    expect(@manager.dalphiBaseUrl).toBe @dalphiUrl
    expect(@manager.projectId).toBe @projectId
  )

  it('has loaded one annotation document by creation', ->
    expect(@manager.documentStore.length).toBe 1
  )

  it('decreases the stored documents by calling next()', ->
    documentPayload = @manager.next()
    expect(@manager.documentStore.length).toBe 0
  )

  it('returns an annotation document equal to the FactoryGirl definition', ->
    documentPayload = @manager.next()
    expect(documentPayload).toBeDefined()
    expect(documentPayload).not.toBe false
    expect(documentPayload.label).toBe 'testlabel'
    expect(documentPayload.content).toBe 'testcontent'
    expect(documentPayload.options[0]).toBe 'option1'
    expect(documentPayload.options[1]).toBe 'option2'
  )

describe 'external API', ->
  describe 'requestNextDocumentPayload', ->
    it('is equal as the manager\'s currentDocument payload', ->
      expect(@manager.documentStore.length).toBe 1
      documentPayload = @manager.next()
      expect(@manager.currentDocument.payload).toBe documentPayload
    )

    it('can request documents if some are already loaded', ->
      expect(@manager.documentStore.length).toBe 1
      callbackCalled = false

      responseProcesor = (documentPayload) ->
        expect(documentPayload).toBeDefined()
        expect(documentPayload).not.toBe false
        expect(documentPayload.label).toBe 'testlabel'
        expect(documentPayload.content).toBe 'testcontent'
        expect(documentPayload.options[0]).toBe 'option1'
        expect(documentPayload.options[1]).toBe 'option2'
        callbackCalled = true

      @manager.requestNextDocumentPayload(responseProcesor)
      expect(callbackCalled).toBe true
    )

    it('will load new documents if the buffer is empty', ->
      expect(@manager.documentStore.length).toBe 1
      documentPayload = @manager.next()
      @manager.currentDocument = undefined
      expect(@manager.documentStore.length).toBe 0

      callbackCalled = false
      ajaxRequest = false

      simulatedAjaxResponse = [{
        payload: {
          label: 'mockedlabel',
          content: 'mockedcontent',
          options: [ 'mockedoption1', 'mockedoption2' ]
        }
      }]

      $.ajax = (ajaxOpts) ->
        ajaxRequest = true
        successCallback = ajaxOpts.success
        successCallback(simulatedAjaxResponse)

      responseProcesor = (documentPayload) ->
        expect(documentPayload).toBeDefined()
        expect(documentPayload).not.toBe false
        expect(documentPayload.label).toBe 'mockedlabel'
        expect(documentPayload.content).toBe 'mockedcontent'
        expect(documentPayload.options[0]).toBe 'mockedoption1'
        expect(documentPayload.options[1]).toBe 'mockedoption2'
        callbackCalled = true

      @manager.requestNextDocumentPayload(responseProcesor)
      expect(callbackCalled).toBe true
      expect(ajaxRequest).toBe true
    )

  describe 'saveDocumentPayload', ->
    it('sets the current document of the manager to undefined', ->
      expect(@manager.documentStore.length).toBe 1
      documentPayload = @manager.next()
      @manager.saveDocumentPayload(documentPayload)
      expect(@manager.currentDocument).not.toBeDefined()
    )

    it('calls the ajaxSuccess callback', ->
      expect(@manager.documentStore.length).toBe 1
      documentPayload = @manager.next()
      expect(documentPayload).toBeDefined()
      expect(documentPayload).not.toBe false

      successStatus = false
      responseProcesor = ->
        successStatus = true

      @manager.saveDocumentPayload(documentPayload, responseProcesor)
      expect(successStatus).toBe true
    )

    xit('integration test - manipulates Dalphi\'s annotation document', ->
      # to be discussed: shall we write integration tests from JS client's perspective?
      expect(@manager.documentStore.length).toBe 1
      documentPayload = @manager.next()
      expect(documentPayload).toBe @manager.currentDocument.payload
      documentId = @manager.currentDocument.id

      expect(documentPayload.options[0]).toBeDefined()
      targetOption = documentPayload.options[0]

      expect(documentPayload.label).not.toBe targetOption
      documentPayload.label = targetOption
      @manager.saveDocumentPayload(documentPayload)

      response = undefined
      $.ajax
        type: 'GET',
        url: "#{@dalphiUrl}/api/v1/annotation_documents/#{documentId}",
        dataType: 'json',
        async: false,
        success: (data) ->
          response = data
        error: ->
          console.log 'error requesting annotation document\'s API (GET)'

      expect(response).toBeDefined()
      expect(response.payload.label).toBe targetOption
    )
