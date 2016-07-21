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
    annotationDocument = @manager.next()
    expect(@manager.documentStore.length).toBe 0
  )

  it('returns an annotation document equal to the FactoryGirl definition', ->
    annotationDocument = @manager.next()
    expect(annotationDocument).toBeDefined()
    expect(annotationDocument).not.toBe false
    expect(annotationDocument.label).toBe 'testlabel'
    expect(annotationDocument.content).toBe 'testcontent'
    expect(annotationDocument.options[0]).toBe 'option1'
    expect(annotationDocument.options[1]).toBe 'option2'
  )

describe 'external API', ->
  describe 'requestNextDocumentPayload', ->
    it('can request documents if some are already loaded', ->
      expect(@manager.documentStore.length).toBe 1
      callbackCalled = false

      responseProcesor = (annotationDocument) ->
        expect(annotationDocument).toBeDefined()
        expect(annotationDocument).not.toBe false
        expect(annotationDocument.label).toBe 'testlabel'
        expect(annotationDocument.content).toBe 'testcontent'
        expect(annotationDocument.options[0]).toBe 'option1'
        expect(annotationDocument.options[1]).toBe 'option2'
        callbackCalled = true

      @manager.requestNextDocumentPayload(responseProcesor)
      expect(callbackCalled).toBe true
    )

    it('will load new documents if the buffer is empty', ->
      expect(@manager.documentStore.length).toBe 1
      annotationDocument = @manager.next()
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

      responseProcesor = (annotationDocument) ->
        expect(annotationDocument).toBeDefined()
        expect(annotationDocument).not.toBe false
        expect(annotationDocument.label).toBe 'mockedlabel'
        expect(annotationDocument.content).toBe 'mockedcontent'
        expect(annotationDocument.options[0]).toBe 'mockedoption1'
        expect(annotationDocument.options[1]).toBe 'mockedoption2'
        callbackCalled = true

      @manager.requestNextDocumentPayload(responseProcesor)
      expect(callbackCalled).toBe true
      expect(ajaxRequest).toBe true
    )

  describe 'saveDocumentPayload', ->
    xit('can save documents via save()', ->
      expect('complexity').toBe('easily testable');
    )
