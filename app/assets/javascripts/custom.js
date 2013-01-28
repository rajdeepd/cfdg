$(document).ready(function(){
    $(".viewMap").on("click",function(){
        $(".mapDiv").css("opacity" , 1);
        $(".mapDiv").css("z-index" , 1000);
//        $(".mapDiv").addClass("slide");
//        if($(".mapDiv").hasClass("slide")){
//            $(".mapDiv").removeClass("slide");
//        }
//        else{
//            $(".mapDiv").css("opacity", 1);
//            $(".viewMap").click(function(){
//                $(".mapDiv").toggle();
//            });
//        }
    });
    $(".close").on("click",function(){
        $(".mapDiv").css("opacity" , 0);
        $(".mapDiv").css("z-index" , -1);
    });
    $(".formBox button , .formBox button").click(function(event){
        event.preventDefault();
    });
    $(".agendaDiv").hide();
    $(".agendaAddDiv .blueBtn").click(function(){
        $(".agendaDiv").show();
        $(".agendaAddDiv").hide();
        return false;
    });
    $(".agendaDiv .bigButton").click(function(){
        $(".agendaAddDiv").show();
        return false;
    });
    $(".speakersList").hide();
    $(".addBox .blueBtn").click(function(){
        $(".speakersList").show();
    });
    $(".nonMember").hide();
    $(".notAMember").click(function(){
       $(".nonMember").show();
    });

});