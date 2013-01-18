App.loadInstitution = (collegeId) ->
  $institution = $('#user_school_info_attributes_institution_id')
  $.get "/educations/institutions", { "college_id": collegeId }, (data, status, xhr) ->
    $institution.empty()
    for institution in data
      $institution.append("<option value='#{institution.id}'>#{institution.name}</option>")
$ ->
  if $("body").data('controller') == 'users' && $("body").data('action') == 'edit'

    $avatarUpload = $("#avatar-upload")
    $avatarLoader = $("#upload-loader")

    # avatar upload:
    $avatarUpload.fileupload
      url: "/users/avatar",
      add: (e, data) ->
        jqXHR = data.submit().success (data, status, xhr) ->
          $('.profile-image').attr('src', data[0])

      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        console.log("Now progress..." + progress)

    $avatarUpload.bind 'fileuploadstart', () -> $avatarLoader.show()
    $avatarUpload.bind 'fileuploadstop', () -> $avatarLoader.hide()

    $.get "/regions", (data, status, xhr) ->
      $('#user_county').data('countries', data.countries)
      $('#user_state').data('states', data.states)
      $('#user_city_id').data('cities', data.cities)

    $('#user_state').change (e) ->
        $city = $('#user_city_id')
        allCities = $city.data('cities')
        stateId = $(e.target).val()
        $colleges = $('#user_school_info_attributes_college_id')
        
        # refresh colleges
        $.get "/educations/colleges", { "state_id": stateId }, (data, status, xhr) ->
           $colleges.empty()

           for college in data
             $colleges.append("<option value='#{college.id}'>#{college.name}</option>")

           App.loadInstitution( data[0].id )


        $city.empty()
        for city in allCities
          if city.state_id - stateId == 0
            $city.append("<option value='#{city.id}'>#{city.name}</option>")

    $("#user_school_info_attributes_college_id").change (e) ->
      App.loadInstitution( $(e.target).val() )

    # tab
    $('input[data-tab]').click (e) ->
      $onTab = $( $(e.target).data('tab') )
      $('.info-blocks .tab').hide()
      $onTab.show()

    # college not found toggle
    $("#college-not-found").click () ->
      $("#select-college").fadeOut "fast", () -> $("#input-college").fadeIn "fast"
      $("#select-institution").fadeOut "fast", () -> $("#input-institution").fadeIn "fast"
      $("#back-to-institution-select").fadeOut "fast"

    $("#institution-not-found").click () ->
      $("#select-institution").fadeOut "fast", () ->
        $("#input-institution").fadeIn "fast"

    $("#back-to-college-select").click () ->
      $("#input-college").fadeOut "fast", () ->
        $("#user_school_info_attributes_other_college_name").val("")
        $("#select-college").fadeIn "fast"
        $("#back-to-institution-select").fadeIn "fast"

    $("#back-to-institution-select").click () ->
      $("#input-institution").fadeOut "fast", () ->
        $("#user_school_info_attributes_other_institution_name").val("")
        $("#select-institution").fadeIn "fast"

    # datepicker
    $("#user_school_info_attributes_graduated_at").datepicker({
      dateFormat: "yy-mm-dd"
    })
