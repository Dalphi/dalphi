class InterfaceTypesForm

  _this = undefined

  constructor: ->
    _this = this

    this.testPayloadEditor = this.initAceEditorWithId('test-payload-editor', 'json')

    $('.interface-type-form').submit((e) ->
      editorValue = _this.testPayloadEditor.getValue()
      $('#hidden-test-payload-editor').val(editorValue)
    )

  initAceEditorWithId: (editor_id, language) ->
    currentValue = $('#hidden-' + editor_id).val()
    editor = ace.edit(editor_id)

    editor.setValue(currentValue, -1)
    editor.setTheme('ace/theme/tomorrow')
    editor.getSession().setMode('ace/mode/' + language)
    editor.setOption('wrap', 80)

    return editor

window.InterfaceTypesForm = InterfaceTypesForm
