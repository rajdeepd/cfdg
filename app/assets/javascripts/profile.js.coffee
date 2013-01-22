$ ->
  if $("body").data('controller') == 'users' and $("body").data('action') == 'profile'
    Chapters.init()
    Chapters.firstChapterClick()
    Events.init()
    Posts.init()

    $resendLink = $("#resend_confirmation")
    $sentLink = $("#confirmation_sent")

    if $resendLink.length > 0
      $resendLink.on 'ajax:success', () ->
        $resendLink.fadeOut "fast", () -> $sentLink.fadeIn "fast"

