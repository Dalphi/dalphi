class text_nominal extends AnnotationIteration
  # uncomment to overwrite interface registration at AnnotationLifecylce
  constructor: ->
    $(document).keypress (e) ->
      $buttons = $('.annotation-interface:not(.template) .annotation-button')
      if e.which == 106
        console.log 'pressed J; emulate left button click'
        $buttons[0].click()
      else if e.which == 107
        console.log 'pressed K; emulate right button click'
        $buttons[1].click()
    super

  annotateWith: (label) ->
    @currentData.label = label
    this.saveChanges(@currentData)

window.text_nominal = new text_nominal()
