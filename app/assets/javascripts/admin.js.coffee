#= require jquery_ujs
$ ->
  if $("body").data('controller') == 'admin'
    # Type here! 
    $("#tabs").tabs
      beforeLoad: (event, ui) ->
        ui.jqXHR.error ->
          ui.panel.html "Couldn't load this tab. We'll try to fix this as soon as possible. " + "If this wouldn't be a demo."

      load: (event, ui) ->
        $(".inner-tabs").tabs
          beforeLoad: (event, ui) ->
            ui.jqXHR.error ->
              ui.panel.html "Couldn't load this tab. We'll try to fix this as soon as possible. " + "If this wouldn't be a demo."

          activate: (event, ui) ->
            ui.newTab.attr "class", "uli-selected"
            ui.oldTab.attr "class", "uli-selected1"

      activate: (event, ui) ->
        ui.newTab.attr "class", "ulf-selected"
        ui.oldTab.attr "class", "ulf-selected1"


    $("#inner-tabs").tabs
      beforeLoad: (event, ui) ->
        ui.jqXHR.error ->
          ui.panel.html "Couldn't load this tab. We'll try to fix this as soon as possible. " + "If this wouldn't be a demo."


      activate: (event, ui) ->
        ui.newTab.attr "class", "uli-selected"
        ui.oldTab.attr "class", "uli-selected1"


        # Changing chapter status
    $(".change_status").die("click").live "click", ->
      obj = $(this)
      $.ajax
        url: obj.attr("data-url")
        success: (data) ->
          $(obj).parent().html data.msg

        contentType: "application/json"
        dataType: "json"


    $(".target").change ->
      locationObj = window.location.href
      if locationObj.match(/(locale=[a-zA-Z]*)/)
        window.location = locationObj.replace(/(locale=[a-zA-Z]*)/, "locale=" + $(this).val())
      else
        window.location = locationObj + "?locale=" + $(this).val()

    $("input:radio[name='chapter[chapter_type]']").click ->
      value = $(this).val()
      if value is "student"
        $("#ct_selection").show()
      else
        $("#ct_selection").hide()

    $("select#chapter_country_name").change (event) ->
      country_code = undefined
      select_wrapper = undefined
      url = undefined
      select_wrapper = $("#chapter_state_name_wrapper")
      $("select", select_wrapper).attr "disabled", true
      country_code = $(this).val()
      url = "/chapters/subregion_options?parent_region=" + country_code
      select_wrapper.load url

    $("#comment_content").die("keypress").live "keypress", (e) ->
      $(this).parents("#new_comment").submit()  if e.keyCode is 13

    $(".comment").die("submit").live "submit", (e) ->
      e.preventDefault()  if e.preventDefault
      $.ajax
        context: this
        type: "POST"
        data: $(this).serialize()
        url: "/events/create_event_comment"
        success: (data) ->
          $(this).parents("li").replaceWith data

        async: false
        dataType: "html"
