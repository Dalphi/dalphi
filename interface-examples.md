## A more advanced interface example of the `text_nominal` type:

## HTML

```html
<div class="description-container">
    <h1>Paragraph Classification</h1>
    <p>
        Choose wether the text below contains a real person name or not.
    </p>

    {{#options}}
        <button class="btn btn-secondary annotation-button" onclick="window.text_nominal.annotateWith('{{.}}')">
            {{.}}
        </button>
    {{/options}}
</div>

<div class="row paragraph-container">
    <div class="col-xs-12 col-sm-8 offset-sm-2">
        <p>
            {{{content}}}
        </p>
    </div>
</div>
```

## SCSS

```scss
.description-container {
    margin: 0 auto;
    text-align: center;
    width: 60%;
}

.paragraph-container {
    margin-top: 2.3rem;

    strong {
        color: #A70000;
        font-size: 1.2rem;
    }
}
```

## CoffeeScript

```coffee
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

    # uncomment to overwrite standard mustache templating
    # iterate: (template, data) ->
    #    # implement your rendering here or call `super`

    annotateWith: (label) ->
        @currentData.label = label
        this.saveChanges(@currentData)

window.text_nominal = new text_nominal()
```
