class AnnotationControls

  _this = this

  constructor: ->
    _this = this

    _this.$firstButton = $('.annotations .navigation .first')
    _this.$previousButton = $('.annotations .navigation .previous')
    _this.$nextButton = $('.annotations .navigation .next')
    _this.$lastButton = $('.annotations .navigation .last')
    _this.$currentAnnotationDocumentIndexLabel = $('.annotations .navigation .current-annotation-document-index')
    _this.$annotationDocumentCountLabel = $('.annotations .navigation .annotation-document-count')

    $('.annotations .navigation .btn').on 'click', ->
      $(this).tooltip('hide')
      $(this).blur()
      if this == _this.$firstButton[0]
        _this.currentAnnotationDocumentIndex = 1
      else if this == _this.$previousButton[0]
        _this.currentAnnotationDocumentIndex -= 1
      else if this == _this.$nextButton[0]
        _this.currentAnnotationDocumentIndex += 1
      else if this == _this.$lastButton[0]
        _this.currentAnnotationDocumentIndex = _this.annotationDocumentCount
      _this.updateCurrentAnnotationDocumentIndex()

    this.updateCurrentAnnotationDocumentIndex(1)
    this.updateAnnotationDocumentCount(1)

  updateControlButtonStates: ->
    firstOrPreviousEnabled = _this.currentAnnotationDocumentIndex > 1
    _this.$firstButton.attr('disabled', !firstOrPreviousEnabled)
    _this.$previousButton.attr('disabled', !firstOrPreviousEnabled)
    nextOrLastEnabled = _this.currentAnnotationDocumentIndex < _this.annotationDocumentCount
    _this.$nextButton.attr('disabled', !nextOrLastEnabled)
    _this.$lastButton.attr('disabled', !nextOrLastEnabled)

  updateCurrentAnnotationDocumentIndex: (currentAnnotationDocumentIndex) ->
    if currentAnnotationDocumentIndex == undefined
      currentAnnotationDocumentIndex = _this.currentAnnotationDocumentIndex
    else
      _this.currentAnnotationDocumentIndex = currentAnnotationDocumentIndex
    _this.$currentAnnotationDocumentIndexLabel.html(currentAnnotationDocumentIndex)
    _this.updateControlButtonStates()

  updateAnnotationDocumentCount: (annotationDocumentCount) ->
    if annotationDocumentCount == undefined
      annotationDocumentCount = _this.annotationDocumentCount
    else
      _this.annotationDocumentCount = annotationDocumentCount
    _this.$annotationDocumentCountLabel.html(annotationDocumentCount)
    _this.updateControlButtonStates()

window.AnnotationControls = AnnotationControls
