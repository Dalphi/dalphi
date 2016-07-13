class InterfacesForm

  _this = undefined

  constructor: ->
    _this = this

    this.$tokenfield = this.initTokenfield()

    this.templateEditor = this.initAceEditorWithId('template-editor', 'html')
    this.javascriptEditor = this.initAceEditorWithId('js-editor', 'coffee')
    this.stylesheetEditor = this.initAceEditorWithId('stylesheet-editor', 'scss')

    $('.interface-form').submit((e) ->
      editorValue = _this.templateEditor.getValue()
      $('#hidden-template-editor').val(editorValue)

      editorValue = _this.javascriptEditor.getValue()
      $('#hidden-js-editor').val(editorValue)

      editorValue = _this.stylesheetEditor.getValue()
      $('#hidden-stylesheet-editor').val(editorValue)
    )

  initTokenfield: ->
    $tokenfield = $('.tokenized-problem-identifiers')
    knownProblemIdentifiers = $tokenfield.data('autocomplete')

    autocomplete = {
      source: knownProblemIdentifiers.split(" "),
      delay: 100
    }

    $tokenfield.tokenfield({
      autocomplete: autocomplete,
      showAutocompleteOnFocus: true
    })

    return $tokenfield

  initAceEditorWithId: (editor_id, language) ->
    currentValue = $('#hidden-' + editor_id).val()
    editor = ace.edit(editor_id)

    editor.setValue(currentValue, -1)
    editor.setTheme('ace/theme/tomorrow')
    editor.getSession().setMode('ace/mode/' + language)

    return editor

window.InterfacesForm = InterfacesForm
