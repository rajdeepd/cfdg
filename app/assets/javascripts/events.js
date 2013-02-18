Events ={

    init:function(){
        $('#create_event').die('click').live('click',function(e){
            e.preventDefault();
            var chapter_id= $('#group_admin_ref').attr('chapter_id');

            $.ajax({
                url: '/chapters/'+ chapter_id+'/events/new',
//          data: {chapter_id: chapter_id},
                success: function(data){

                    $('#admincontent').html(data);
                },
                async:false,
                dataType: 'html'
            });
        });


        $('#follow_an_event').die('click').live('click', function(e){

            var data = {event_id: $(this).attr('event_id')};
            $(this).text("please wait...");
            $(this).css("opacity",0.35);
            $(this).attr("disabled","disabled");

            $.ajax({
                url: '/events/follow_an_event',
                data : data,
                success: function(data){
                    $('#events').html(data);
                    $('.join_us').hide();
                },
                async:false,
                dataType: 'html'
            });

        });
        $('#delete_an_event').die('click').live('click', function(e){

            var data = {event_id: $(this).attr('event_id')};
            var confirmation = confirm("Are you sure you want to delete this event?")

            if (confirmation == true)
            {
                $.ajax({
                    url: '/events/delete_an_event',
                    data : data,
                    success: function(data){
                        $('#events').html(data);
                    },
                    async:false,
                    dataType: 'html'
                });
            }

        });

        $('#cancel_an_event').die('click').live('click', function(e){

            var data = {event_id: $(this).attr('event_id')};
            $(this).text("please wait...");
            $(this).css("opacity",0.35);
            $(this).attr("disabled","disabled");
            var confirmation = confirm("Are you sure you want to cancel this event?")
            if (confirmation == true)
            {
                $.ajax({
                    url: '/events/cancel_event',
                    data : data,
                    async:false,
                    dataType: 'html',
                    success: function(data){
                        $('#events').html(data);
                    }
                });
            }else{
                $(this).text("CANCEL");
                $(this).css("opacity",1);
                $(this).attr("disabled",false);
            }

        });

        $('#event_form_submit').die('click').live('click', function(e){
//    $('#options').hide();
//    $('#spinner').show();
        });

        /*  $('.event_expand').die('click').live('click', function(e){

         e.preventDefault();
         var data = {event_id: $(this).attr('event_id')};
         $.ajax({
         context: this,
         url: '/events/full_event_content',
         data : data,
         success: function(data){
         $(this).parents("li").replaceWith(data);
         },
         async:false,
         dataType: 'html'
         });

         });
         */
        $('#upcoming_events').die('click').live('click', function(e){
            e.preventDefault();
            var default_text= "See all upcoming events...";
            $('#two_events').toggle();
            $('#all_events').toggle();
            if($('#two_events').is(':hidden')){
                default_text = "collapse"
            }
            $('#upcoming_events').text(default_text);

        });

        $('#edit_agenda').die('click').live('click', function(e){
            $('#agenda_text_area').show();
        });

    }

}

