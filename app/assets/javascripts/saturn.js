$(document).ready(function(){
		$(".inputHidden").change(function() {
			var valInput = $(".textbox");
			valInput.val($(".inputHidden").val());
		});
	})