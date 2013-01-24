$ ->
  $('#photo-upload').fileupload
    dataType: "script"
    url: "/admin/anouncements"
    add: (e, data) ->
      data.submit()
      #add: (e, data) ->
      #  types = /(\.|\/)(gif|jpe?g|png)$/i
      #  file = data.files[0]
      #  if types.test(file.type) || types.test(file.name)
      #    data.context = $(tmpl("template-upload", file))
      #    $('#new_painting').append(data.context)
      #    data.submit()
      #  else
      #    alert("#{file.name} is not a gif, jpeg, or png image file")
    progress: (e, data) ->
      if data.context
        progress = parseInt(data.loaded / data.total * 100, 10)
        console.log("Now progress..." + progress)
        #data.context.find('.bar').css('width', progress + '%')
