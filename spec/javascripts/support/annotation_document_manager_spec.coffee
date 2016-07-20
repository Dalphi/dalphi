#= require annotation_document_manager

beforeAll ->
  console.log 'beforeAll'
  Teaspoon.hook('setup')
  Teaspoon.hook('create_annotation_document')

  fixture.preload('parameters.html')
  parameterFixtures = fixture.load('parameters.html', true)

  @dalphiUrl = "#{Teaspoon.location}".match(/http[s]*:\/\/[0-9a-z\.:]+/)[0]
  @projectId = $('.data-container-project-reference', parameterFixtures).data('project-reference')

describe 'internal API', ->
  beforeEach ->
    console.log 'beforeEach internal API'
    Teaspoon.hook('create_annotation_document')
    @manager = new window.AnnotationDocumentManager(@dalphiUrl, @projectId, true)

  it('should have created a valid manager object', ->
    expect(@manager).toBeDefined()
    expect(@manager.dalphiBaseUrl).toBe @dalphiUrl
    expect(@manager.projectId).toBe @projectId
  )

  it('has loaded one annotation document by creation', ->
    console.log 'start spec 1'
    expect(@manager.count()).toBe 1
    console.log 'end spec 1'
  )

  it('decreases the stored documents by calling next()', ->
    console.log 'start spec 2'
    annotaionDocument = @manager.next()
    expect(@manager.count()).toBe 0
    console.log 'end spec 2'
  )

  it('returns an annotation document equal to the FactoryGirl definition', ->
    console.log 'start spec 3'
    annotaionDocument = @manager.next()
    expect(annotaionDocument).toBeDefined()
    console.log annotaionDocument
    # expect(annotaionDocument).not.toBe false
    expect(annotaionDocument.label).toBe 'testLabel'
    # expect(annotaionDocument.content).toBe 'testcontent'
    # expect(annotaionDocument.options[0]).toBe 'option1'
    # expect(annotaionDocument.options[1]).toBe 'option2'
    console.log 'end spec 3'
  )

describe 'external API', ->
  beforeAll ->
    Teaspoon.hook('create_annotation_document')
