class AnnotationDocumentsEditor

  constructor: ->
    this.annotationDocumentsEditor = this.initAceEditorWithId('annotation-documents', 'json')

  initAceEditorWithId: (editor_id, language) ->
    currentValue = $('#' + editor_id).html()
    editor = ace.edit(editor_id)

    editor.setValue(currentValue, -1)
    editor.setTheme('ace/theme/tomorrow')
    editor.getSession().setMode('ace/mode/' + language)
    editor.setOption('wrap', 80)

    return editor

window.AnnotationDocumentsEditor = AnnotationDocumentsEditor
