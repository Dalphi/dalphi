class InterfacesForm

  _this = undefined

  constructor: ->
    _this = this

    # this.$tokenfield = $('.tokenized_problem_identifiers')
    # $tokenfield = $('.tokenized_problem_identifiers')
    # known_problem_identifiers = this.$tokenfield.data('autocomplete')
    # this.autocomplete_suggestions = known_problem_identifiers.split(" ")

    # $tokenfield.tokenfield()
    # this.initTokenfield()

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

  # initTokenfield: ->
  #   autocomplete = {
  #     source: this.autocomplete_suggestions,
  #     delay: 100
  #   }
  #   this.$tokenfield.tokenfield({
  #     autocomplete: autocomplete,
  #     showAutocompleteOnFocus: true
  #   })

  initAceEditorWithId: (editor_id, language) ->
    currentValue = $('#hidden-' + editor_id).val()
    editor = ace.edit(editor_id)

    editor.setValue(currentValue, -1)
    editor.setTheme('ace/theme/tomorrow')
    editor.getSession().setMode('ace/mode/' + language)

    return editor

window.InterfacesForm = InterfacesForm
