// Place all the behaviors and hooks related to the matching controller here.
//All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
//var Usergroups = Usergroups || {};
Chapters ={

    renderContent: function(element, type, chapter_id){
        var id = (typeof chapter_id != 'undefined') ?  chapter_id : element.attr('id')
        // Changing chapter status
        var data = {chapter_id: id};
        var url = '/events/userevents';
        switch(type){
            case "Post":
                data = $.extend(data,{profile_page:'true'})
                url = "/posts/chapterposts";
                break;
            default:
                url = "/events/userevents";
                break;
        }

        $.ajax({
            url: url,
            data : data,
            success: function(data){
                $('#event_content').html(data);
                // $('#groupadmin').html("");
            },
            async:false,
            dataType: 'html'
        });

    },
    renderMessages: function(element){
        // messages
        $.ajax({
            url: '/messages',
            data : [],
            success: function(data){
                //$('#event_content').html("");
                $('#event_content').html(data);
            },
            async:false,
            dataType: 'html'
        });

    },
    renderChapterAdmin: function(element){
        // Changing chapter status
        var data = {chapter_id: element.attr('chapter_id')};

        $.ajax({
            url: '/chapters/chapter_admin_home_page',
            data : data,
            success: function(data){
                //$('#event_content').html("");
                $('#events').html(data);
            },
            async:false,
            dataType: 'html'
        });

    },

    firstChapterClick: function(){
        setTimeout(function(){
            $($('.chapter_link')[0]).click();},10);
    },

    renderEventForm: function(target){
        window.location = $(target).attr('href')+"&from=chapter&chapter_id="+$(target).attr('chapter_id');
    },

    fireclicks: function(chapter_id){


        setTimeout(function(){$('#'+chapter_id).trigger('click');$('#group_admin_ref').trigger('click');$('#create_event').trigger('click');}, 10);
    },

    init: function(){
        $( "#profiletabs").tabs({
            beforeLoad: function( event, ui ) {
                ui.jqXHR.error(function() {
                    ui.panel.html("Couldn't load this tab. We'll try to fix this as soon as possible. " +    "If this wouldn't be a demo." );});
            }
        });
        //userprofile jquery
        $('.ul-f, .ul-i').unbind('click').bind('click', function(e){
            e.preventDefault();


            var selectedClass="ulf-selected";

            if($(this).hasClass('ul-i')){ //if a chapter group is clicked
                selectedClass="uli-selected";
                //check to render events or posts or messages or multimedia
                Chapters.renderContent($(e.target), $('.ul-f .ulf-selected a').text());


            }
            /*else if ($(this).hasClass('ul-f')){
             Chapters.renderContent($(e.target), $('.ul-f .ulf-selected a').text(), $('.ul-f .ulf-selected a').attr('chapter_id'));
             }     */
            if($(e.target).text() == "Chapter Admin"){
                //$($('.profile_content')[0]).hide(); //hide the chapters ul for admin
                Chapters.renderChapterAdmin($(e.target))
            }else if($(e.target).text() == "Messages"){
                $($('.profile_content')[0]).hide();
                Chapters.renderMessages($(e.target))
            }else if($(e.target).attr('id') == "create_event_from_chapter") {
                Chapters.renderEventForm(e.target);
                return;

            }else if($(e.target).text() == "Events" || $(e.target).text() == "Photos" || $(e.target).text() == "Post"){
                $($('.profile_content')[0]).show();
                $('#event_content').html("");
                Chapters.renderContent($(e.target), $(e.target).text(), $(e.target).attr('chapter_id'));

            }


            $(this).children("li").each(function(i, element){
                $(element).removeClass(selectedClass);
            });
            $(e.target).parent("li").addClass(selectedClass);

        });
        $('#chapter_page_posts').unbind('click').bind('click', function(e){
            var data = {chapter_id: $('#chapter_page_posts').attr('chapter_id'), chapter_home: "true"};
            $.ajax({
                url: '/posts/chapterposts',
                data : data,
                success: function(data){
                    $('#chapter_show_events').html(data);

                },
                async:false,
                dataType: 'html'
            });

        });
        $('#chapter_page_events').unbind('click').bind('click', function(e){
            var chapter_id = $('#chapter_page_posts').attr('chapter_id')
            var data = {chapter_home: "true"};
            $.ajax({
                url: '/chapters/'+chapter_id,
                data : data,
                success: function(data){
                    $('#chapter_show_events').html(data);

                },
                async:false,
                dataType: 'html'
            });

        });


    }



}