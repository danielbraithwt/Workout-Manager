$(function () {
		$(document).tooltip();
		});

$(document).ready( function () {
		
		var children = $("#workouts").children("div");
		var max_range = children.length;
		if( max_range < 10 ) max_range = 10;

		var i = 1;

		children.each( function() {
				
				$(this).children("div").each( function() {	
					var rgb = HSBtoRGB(i * (100.0 / max_range), 0.68, 0.72);
					$(this).animate({backgroundColor: "rgb(" + parseInt(rgb[0]) + ", " + parseInt(rgb[1]) + ", " + parseInt(rgb[2]) + ")"});

					i += 1;
					});

				});

		});
