#= require annotation_document_manager

before ->
  @dalphiUrl = "#{Teaspoon.location}".match(/http[s]*:\/\/[0-9a-z\.:]+/)[0]
  @manager = new window.AnnotationDocumentManager(@dalphiUrl)

it('should have created a valid manager object', ->
  expect(@manager).to.not.be(undefined)
  expect(@manager.dalphiBaseUrl).to.be(@dalphiUrl)
)

describe 'load annotation documents', ->

  it('has loaded', ->
    expect(true).to.be(true)
    expect(jQuery).to.not.be(undefined)
  )
