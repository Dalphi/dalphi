class AnnotationLifecycleFaker
  _this = undefined

  constructor: ->
    _this = this

  annotateWith: (data) ->
    console.log "annotate document with '#{data}'"

  skip: ->
    console.log 'skip this annotation document'

class InterfaceTest
  _this = undefined

  constructor: ->
    _this = this

    $staging = $('.interfaces-staging')

    # fake annotation_lifecycle functionallity
    window[$staging.data('interface-type-name')] = new AnnotationLifecycleFaker()

    # render templat with test payload & append to DOM
    mustacheParsedTemplate = Mustache.render(
      $staging.data('template'),
      $staging.data('test-payload')
    )
    $('.interfaces-staging').append(mustacheParsedTemplate)

    # append JS to DOM
    $('.interfaces-staging').append("<script>#{$staging.data('js-script')}</script>")

window.InterfaceTest = InterfaceTest
