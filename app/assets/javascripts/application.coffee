#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require_tree .
#= require tether
#= require bootstrap-sprockets
#= require cookies_eu
#= require fastclick
#= require hammer
#= require modernizr

$ ->
  Turbolinks.enableProgressBar()
  new FastClick(document.body)
