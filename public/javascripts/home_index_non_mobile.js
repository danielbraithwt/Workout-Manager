$(window).on("load resize", function() {

		// Based on the current size of the div determin the number of columns
		// there should be
		var size = $("#workouts").width();
		var num_of_columns = parseInt(size / 300);
		if( num_of_columns < 1 ) num_of_columns = 1;

		// If we allready have the right ammount of columns then just quit
		// out of function
		if( $("#workouts").children().length == num_of_columns ) return;

		// Get all the workouts into an array
		var workouts = [];

		$("#workouts").children("div").each( function() {
				$(this).children("div").each( function() {
						workouts.push(this);
						});
				});

		// Update the left padding for the workouts div so everythign is centered
		var left_padding = size - ( num_of_columns * 300 ) - ( num_of_columns * 20 );
		$("#workouts").css("padding-left", (left_padding + "px"));

		// Clear the workouts from the screen, add the number of columns there should be
		// and then add all the workouts back into the DOM
		document.getElementById("workouts").innerHTML = "";

		for( var i = 0; i < num_of_columns; i += 1 )
		{
			var column = document.createElement("div");
			column.id = ("column_" + i);
			column.className = "column";

			document.getElementById("workouts").appendChild(column);	
		}

		while( workouts.length != 0 )
		{
			for( var i = 0; i < num_of_columns; i += 1 )
			{
				if( workouts.length != 0 )
				{
					document.getElementById("column_" + i).appendChild(workouts.shift());		
				}
			}
		}

	});

