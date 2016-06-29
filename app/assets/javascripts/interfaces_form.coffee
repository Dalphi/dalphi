class InterfacesForm
  constructor: ->
    $tokenfield = $('.tokenized_problem_identifiers')
    known_problem_identifiers = $tokenfield.data('autocomplete')
    autocomplete_suggestions = known_problem_identifiers.split(" ")

    $tokenfield.tokenfield({
      autocomplete: {
        source: autocomplete_suggestions,
        delay: 100
      },
      showAutocompleteOnFocus: true
    })

window.InterfacesForm = InterfacesForm
