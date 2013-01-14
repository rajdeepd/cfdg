App.loadInstitution = (collegeId) ->
  $institution = $('#user_school_info_attributes_institution_id') 
  $.get "/educations/institutions", { "college_id": collegeId }, (data, status, xhr) ->
    $institution.empty();
    for institution in data
      $institution.append("<option value='#{institution.id}'>#{institution.name}</option>"); 
$ ->
  if $("body").data('controller') == 'users' && $("body").data('action') == 'edit'
    $('#avatar-upload').fileupload
      url: "/users/avatar",
      add: (e, data) ->
        jqXHR = data.submit().success () ->
          $('.profile-image').attr('src', result[0])

      progressall: (e, data) ->        
        progress = parseInt(data.loaded / data.total * 100, 10)
        console.log("Now progress..." + progress)

    $.get "/regions", (data, status, xhr) ->
      $('#user_county').data('countries', data.countries);
      $('#user_state').data('states', data.states);
      $('#user_city_id').data('cities', data.cities);

    $('#user_state').change (e) ->
        $city = $('#user_city_id');
        allCities = $city.data('cities');
        stateId = $(e.target).val();
        $colleges = $('#user_school_info_attributes_college_id')
        
        # refresh colleges
        $.get "/educations/colleges", { "state_id": stateId }, (data, status, xhr) ->
           $colleges.empty();

           for college in data
             $colleges.append("<option value='#{college.id}'>#{college.name}</option>") for college in data

           App.loadInstitution( data[0].id )


        $city.empty();
        for city in allCities
          if city.state_id - stateId == 0
            $city.append("<option value='#{city.id}'>#{city.name}</option>")

    $("#user_school_info_attributes_college_id").change (e) ->
      App.loadInstitution( $(e.target).val() );
