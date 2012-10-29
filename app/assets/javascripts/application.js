// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function(){  
  $('.signin').click(function(){
    $('#navbar').accountChooser('showAccountChooser');   
  });
  $('.logout').click(function(){
    window.location = window.google.identitytoolkit.easyrp.config.logoutUrl;
  });

   // Admin Tab System
   $( "#tabs" ).tabs({
          beforeLoad: function( event, ui ) {            
              ui.jqXHR.error(function() {
                  ui.panel.html(
                      "Couldn't load this tab. We'll try to fix this as soon as possible. " +
                      "If this wouldn't be a demo." );
              });
          },
          activate: function( event, ui ){
            ui.newTab.attr('class','ulf-selected')
            ui.oldTab.attr('class','ulf-selected1')
          }
      });
   
   $( "#inner-tabs" ).tabs({
          beforeLoad: function( event, ui ) {
              ui.jqXHR.error(function() {
                  ui.panel.html(
                      "Couldn't load this tab. We'll try to fix this as soon as possible. " +
                      "If this wouldn't be a demo." );
              });
          }
     });
  
   // Changing chapter status
    $(".change_status").die('click').live('click',function(){
      var obj = $(this)
      $.ajax({
        url: obj.attr('data-url'),
        success: function(data){
            $(obj).parent().html(data.msg)
        },
        contentType: "application/json",
        dataType: 'json'
      });
    });   


   $(".target").change(function () {
        var locationObj = window.location.href;        
        if(locationObj.match(/(locale=[a-zA-Z]*)/)){
          window.location = locationObj.replace(/(locale=[a-zA-Z]*)/,'locale=' + $(this).val())
        }
        else
          {
            window.location = locationObj+"?locale=" + $(this).val();
          }
       });

       $("input:radio[name='chapter[chapter_type]']").click(function() {
            var value = $(this).val();
            if(value == "student"){
              $('#ct_selection').show();
            }else{
              $('#ct_selection').hide();
            }            
        });
});
