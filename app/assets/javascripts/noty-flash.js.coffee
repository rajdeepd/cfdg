$.noty.defaults.timeout = 8000
$.noty.defaults.layout = 'topCenter'

$ ->
  $flash = $("p.flash")
  
  if $flash.length > 0
    notyType = $flash.data("noty")
    msgSpans = $flash.children("span")

    notyMessage = ""

    for spn in msgSpans
      notyMessage = "#{notyMessage}<br />" if notyMessage.length > 0
      notyMessage = "#{notyMessage}#{$(spn).text()}"

    noty { text: notyMessage, type: notyType }
