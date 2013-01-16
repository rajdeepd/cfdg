$.noty.defaults.timeout = 8000
$.noty.defaults.layout = 'topCenter'

$ ->
  $flash = $("p.flash")
  
  if $flash.length > 0
    notyType = $flash.data("noty")
    notyMessage = $flash.text()

    noty { text: notyMessage, type: notyType }
