#= require annotation_document_manager

beforeAll ->
  Teaspoon.hook('setup')
  Teaspoon.hook('create_annotation_document')

  fixture.preload('parameters.html')
  parameterFixtures = fixture.load('parameters.html', true)

  @dalphiUrl = "#{Teaspoon.location}".match(/http[s]*:\/\/[0-9a-z\.:]+/)[0]
  @projectId = $('.data-container-project-reference', parameterFixtures).data('project-reference')

describe 'internal API', ->
  beforeEach ->
    Teaspoon.hook('create_annotation_document')
    @manager = new window.AnnotationDocumentManager(@dalphiUrl, @projectId, true)

  it('should have created a valid manager object', ->
    expect(@manager).toBeDefined()
    expect(@manager.dalphiBaseUrl).toBe @dalphiUrl
    expect(@manager.projectId).toBe @projectId
  )

  it('has loaded one annotation document by creation', ->
    expect(@manager.documentStore.length).toBe 1
  )

  it('decreases the stored documents by calling next()', ->
    annotaionDocument = @manager.next()
    expect(@manager.documentStore.length).toBe 0
  )

  it('returns an annotation document equal to the FactoryGirl definition', ->
    annotaionDocument = @manager.next()
    expect(annotaionDocument).not.toBe false
    expect(annotaionDocument).toBeDefined()
    expect(annotaionDocument.label).toBe 'testlabel'
    expect(annotaionDocument.content).toBe 'testcontent'
    expect(annotaionDocument.options[0]).toBe 'option1'
    expect(annotaionDocument.options[1]).toBe 'option2'
  )

describe 'external API', ->
  beforeAll ->
    Teaspoon.hook('create_annotation_document')

  it('hasn\'t been tested yet')

  xit('can request documents via requestNextDocumentPayload()', ->
    expect('complexity').toBe('easily testable');
  )

  xit('can save documents via save()', ->
    expect('complexity').toBe('easily testable');
  )
