$ ->
  $loginDialog = $("#login-dialog")
  $loginLink = $('.login')
  $signinLink = $('.signin')

  if $loginDialog.length > 0
    $loginDialog.dialog
      autoOpen: false
      show: "blind"
      hide: "explode"

  if $loginLink.length > 0
    $loginLink.click (e) ->
      e.preventDefault()
      $("#login-dialog").dialog('open')

  if $signinLink.length > 0
    $signinLink.click (e) ->
      e.preventDefault()
      $("#login-dialog").dialog('open')
