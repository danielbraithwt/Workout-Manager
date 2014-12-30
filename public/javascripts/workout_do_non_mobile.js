function toggle_sets(id)
{
	if( id == last_toggled )
	{
		last_toggled = -1;
	}
	else if( last_toggled == -1 )
	{
		last_toggled = id;
	}
	else
	{
		toggle_sets(last_toggled);
		last_toggled = id;
	}

	if( $("#excersise_" + id).width() == 350 )
	{
		var new_height = ($("#excersise_sets_" + id).height() + 140);
		if( new_height < 350 ) new_height = 350;

		$("#excersise_" + id).animate({width: "700px", height: (new_height + "px")}, 200, function() {
				$("#excersise_sets_" + id).css({visibility: "visible"});
				});
	}
	else
	{
		$("#excersise_sets_" + id).css({visibility: "hidden"});
		$("#excersise_" + id).animate({width: "350px", height: "350px"}, 200);
	}
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

function remove_set(id, set_number)
{
	$("#excersise_set_" + id + "_" + set_number).animate({opacity: 0}, 200, function() {
			$("#excersise_set_" + id + "_" + set_number).remove();
			update_set_numbers(id);
			});

	excersise_information[id][2] -= 1;

	var new_height = ($("#excersise_sets_" + id).height() + 140);
	if( new_height < 300 ) new_height = 300;

	$("#excersise_" + id).animate({height: (new_height + "px")}, 200);
}
