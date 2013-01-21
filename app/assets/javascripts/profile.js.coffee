$ ->
  if $("body").data('controller') == 'users' and $("body").data('action') == 'profile'
    Chapters.init()
    Chapters.firstChapterClick()
    Events.init()
    Posts.init()
