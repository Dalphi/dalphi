class AnnotationLifecycleFaker
  _this = undefined

  constructor: ->
    _this = this

  annotateWith: (data) ->
    console.log "annotate document with '#{data}'"

  skip: ->
    console.log 'skip this annotation document'

  registerInterfaceInstance: (typeName, _) ->
    console.log "registering interface: #{typeName}"

class InterfaceTest
  _this = undefined

  constructor: ->
    _this = this

    interfaceContainer = $('.interfaces-staging').data('container-class-name')
    $interfaceContainer = $(".#{interfaceContainer}")

    # fake annotation_lifecycle functionallity
    window[$interfaceContainer.data('interface-type-name')] = new AnnotationLifecycleFaker()
    window.annotationLifecycle = new AnnotationLifecycleFaker()

    # render template with test payload & append to DOM
    mustacheParsedTemplate = Mustache.render(
      $interfaceContainer.data('template'),
      $interfaceContainer.data('test-payload')
    )
    $interfaceContainer.append(mustacheParsedTemplate)

    # append JS to DOM
    $interfaceContainer.append("<script>#{$interfaceContainer.data('js-script')}</script>")

window.InterfaceTest = InterfaceTest
