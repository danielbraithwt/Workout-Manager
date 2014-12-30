$(function () {
	
	var max_range = largest_group;
	if( max_range < 10 ) max_range = 10;

	var i = 0;
	$("#excersises").children().each( function() {
		
		if( $(this).attr('id').indexOf("rest") == -1 )
		{
			var rgb = HSBtoRGB(excersise_group_order[i] * (100.0/max_range), 0.68, 0.66);
			$(this).animate({backgroundColor: "rgb(" + parseInt(rgb[0]) + ", " + parseInt(rgb[1]) + ", " + parseInt(rgb[2]) + ")"});

			i += 1;
		}
		});

	//$("#excersise_letter_" + current_excersise_id).animate({backgroundColor: "#2196F3"});

	});



function start_workout()
{
	$("#start_workout_button").animate({opacity: 0}, 200, function() {
			$("#start_workout_button").remove();

			var top = $("#excersise_" + current_excersise_id).offset().top;
			$("html,body").animate({ scrollTop: top - 20}, 1000);
			});

	$("#excersise_letter_" + current_excersise_id).animate({backgroundColor: "#2196F3"});

	workout_start_time = new Date().getTime();

	//var top = $("#excersise_" + current_excersise_id).offset().top;
	//window.scroll(0, top);
}

function go(id)
{
	if( resting || id != current_excersise_id || excersise_start_time != -1 )
	{
		return false;
	}


	excersise_start_time = new Date().getTime();
}

function next(id)
{
	//var possible_next_id = excersise_information[current_excersise_id][0];
	var next_id = -1;

	// Make sure the right button was clicked and that the excersise has actually been done
	if( (!( resting && id == ("group_" + excersise_information[current_excersise_id][1]) ) && !( !resting && id == current_excersise_id )) || ( !resting && excersise_start_time == -1 ) )
	{
		return false;
	}

	// Store the ammount of time it took to complete that set
	excersise_total_time = new Date().getTime() - excersise_start_time;

	if( set_times[id] == null )
	{
		set_times[id] = [];
	}	
	set_times[id].push(excersise_total_time);

	excersise_start_time = -1;
	excersise_total_time = -1;

	if( resting )
	{
		$("#rest_group_" + excersise_information[current_excersise_id][1]).animate({backgroundColor: "rgba(255, 255, 255, 0.2)"});

		// Subtract 1 from the index because the grouops are indexeded 1 .. * but the 
		// array is 0 .. *-1
		var group_start_id = group_starting_excersise[excersise_information[current_excersise_id][1] - 1];
		//resting = false;

		// Make sure that the next excersise has sets left
		if( excersise_information[group_start_id][2] > 0 )
		{
			next_id = group_start_id;	
		}
		else
		{
			current_excersise_id = group_start_id;
		}
	}
	else
	{
		excersise_information[current_excersise_id][2] -= 1;
		$("#excersise_letter_" + current_excersise_id).animate({backgroundColor: "rgba(255, 255, 255, 0.2)"});
	}
	
	var possible_next_id = excersise_information[current_excersise_id][0];
	
	// Find an excersise in the current group after the current excersise
	// that still has sets left to do
	while( next_id == -1 && possible_next_id != -1 )
	{
		if( excersise_information[possible_next_id][2] > 0 )
		{
			next_id = possible_next_id;
		}
		else
		{
			possible_next_id = excersise_information[possible_next_id][0];
		}		
	}

	var top = 0;

	// If the next excersise was found then highlight the next
	// excersise
	if( next_id != -1 )
	{
		//$("#excersise_letter_" + current_excersise_id).animate({"backgroundColor": "rgba(255,255,255, 0.2)"});
		resting = false;

		current_excersise_id = next_id;
		$("#excersise_letter_" + current_excersise_id).animate({backgroundColor: "#2196F3"});

		top = $("#excersise_" + current_excersise_id).offset().top;
	}
	else if( next_id == -1 && resting )
	{
		if( excersise_information[current_excersise_id][1] < group_starting_excersise.length )
		{
			current_excersise_id = group_starting_excersise[excersise_information[current_excersise_id][1]];

			//current_excersise_id = next_id;
			$("#excersise_letter_" + current_excersise_id).animate({backgroundColor: "#2196F3"});

			top = $("#excersise_" + current_excersise_id).offset().top;

			//excersise_information[current_excersise_id][2] -= 1;

			resting = false;

		}
		else
		{
			$("#rest_group_done").animate({backgroundColor: "#2196F3"});

			total_workout_time = new Date().getTime() - workout_start_time;

			top = $("#rest_group_done").offset().top;

			finished = true;

		}
	}
	// Else the set is finished so if this wasnt the last set then highlight the rest box
	else //if( excersise_information[current_excersise_id][1] != largest_group )
	{
		$("#rest_group_" + excersise_information[current_excersise_id][1]).animate({backgroundColor: "#2196F3"});

		top = $("#rest_group_" + excersise_information[current_excersise_id][1]).offset().top;

		resting = true;
	}

	$("html,body").animate({ scrollTop: top - 20}, 1000);
	// Otherwise the workout has been finished
	//else
	//{
	//	$("#rest_group_done").animate({"backgroudColor": "#2196F3"});
	//	finished = true;
	//}
}

function finish()
{
	if( !finished )
	{
		return false;
	}

	
	// Collect all the data to be saved into a record
	var paramaters = "?id=" + workout_id + "&time=" + total_workout_time;

	var excersise_ids = Object.keys(excersise_information);
	for( var i = 0; i < excersise_ids.length; i += 1 )
	{
		var current_excersise = excersise_ids[i];
		var sets = $("#excersise_sets_" + current_excersise).children();

		var set_record_array = []

		for( var j = 1; j < sets.length; j += 1 )
		{
			var reps = document.getElementById("excersise_set_reps_" + current_excersise + "_" + j).innerHTML.trim();
			var diffculty = 0;

			if(	document.getElementById("excersise_set_diffculty_" + current_excersise + "_" + j) != null )
			{
				diffculty = document.getElementById("excersise_set_diffculty_" + current_excersise + "_" + j).innerHTML.trim();	
			}

			set_record_array.push([reps, diffculty, set_times[current_excersise][j-1]]);
		}

		paramaters += "&" + current_excersise + "=" + JSON.stringify(set_record_array);
	}	
	
	var xmlhttp;

	if( window.XMLHttpRequest )
	{
		xmlhttp = new XMLHttpRequest();
	}
	else
	{
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}

	xmlhttp.open("GET", "/workouts/create_record" + paramaters, true);
	xmlhttp.send();

	// Then redirect to the home page
	window.location = "/";
}

function add_set(id)
{
	var set_id = next_id(id);

	var set = document.createElement('div');
	set.id = ("excersise_set_" + id + "_" + set_id);
	set.className = "excersise_set";

	var set_number = document.createElement('div');
	set_number.id = ("excersise_set_number_" + id + "_" + set_id);
	set_number.className = "excersise_set_number";
	set.appendChild(set_number);

	var set_reps = document.createElement('div');
	set_reps.id = ("excersise_set_reps_" + id + "_" + set_id);
	set_reps.className = "excersise_set_reps";
	set_reps.innerText = "0";
	set_reps.contentEditable = "true";
	set.appendChild(set_reps);

	var set_diffculty = document.createElement('div');
	set_diffculty.id = ("excersise_set_diffculty_" + id + "_" + set_id);
	set_diffculty.className = "excersise_set_diffculty";
	set_diffculty.innerText = "0";
	set_diffculty.contentEditable = "true";
	set.appendChild(set_diffculty);

	var set_units = document.createElement('div');
	set_units.className = "excersise_set_diffculty_units";
	set_units.innerText = excersise_units[id];
	set.appendChild(set_units);

	var set_delete = document.createElement('div');
	set_delete.className = "excersise_set_delete";
	set_delete.addEventListener("mouseup", function() { remove_set(id, set_id);  });
	set_delete.innerText = "X";
	set.appendChild(set_delete);

	var sets = document.getElementById("excersise_sets_" + id);
	sets.insertBefore(set, sets.childNodes[sets.childNodes.length - 2]);

	excersise_information[id][2] += 1;

	var new_height = ($("#excersise_sets_" + id).height() + 140);
	if( new_height < 300 ) new_height = 300;

	$("#excersise_" + id).animate({height: (new_height + "px")}, 200);

	update_set_numbers(id);
}

function update_set_numbers(id)
{
	var num = 1;
	var children = $("#excersise_sets_" + id).children("div");

	for( var i = 1; i < children.length - 1; i += 1 )
	{
		var id_split = $(children[i]).attr('id').split('_');
		var set_id = id_split[id_split.length-1];

		$("#excersise_set_number_" + id + "_" + set_id).text("Set " + num);
		num += 1;
	}

}

function next_id(id)
{
	var max_id = 0;
	var children = $("#excersise_sets_" + id).children("div");

	for( var i = 1; i < children.length - 1; i += 1 )
	{
		var id_split = $(children[i]).attr('id').split('_');
		var set_id = id_split[id_split.length-1];
		
		var max_id = parseInt(set_id);
	}

	return max_id + 1;
}

