function graph(x_data, y_data, c2d, color, border)
{
	clear_canvas(c2d);

	x_max = get_max(x_data);
	y_max = get_max(y_data);

	draw_axis(c2d, x_max, y_max, border);
	plot_data(c2d, x_data, x_max, y_data, y_max, color, border);
}

///////////////////////
// Drawing Functions //
///////////////////////

function clear_canvas(c2d)
{
	c2d.fillStyle = "#FFFFFF";
	c2d.fillRect(0, 0, c2d.canvas.width, c2d.canvas.height);
}

function draw_axis(c2d, x_max, y_max, border)
{
	// Draw the X-Axis, starting with a solid line
	c2d.beginPath();
	c2d.strokeStyle = "#000000";
	c2d.lineWidth = 2
	c2d.moveTo(border, c2d.canvas.height - border);
	c2d.lineTo(c2d.canvas.width - border, c2d.canvas.height - border);
	c2d.stroke();

	// TODO: Now draw the refrence points on the line
	for( var i = 0; i <= 1; i += 0.25 )
	{
		var x = border + i * (c2d.canvas.width - 2 * border);
		var y = c2d.canvas.height - border;

		// Draw the text
		c2d.fillStyle = "black";
		c2d.font = "10px Times Roman";
		c2d.fillText(parseInt(x_max * (parseInt(x - border)/(c2d.canvas.width - 2 * border))), x-4, y + border);

		// Draw the line stub
		c2d.beginPath();
		c2d.strokeStyle = "#000000";
		c2d.lineWidth = 2;
		c2d.moveTo(x, y);
		c2d.lineTo(x, y-3);
		c2d.stroke();

	}
	
	// Draw the Y-Axis lines
	for( var i = 0; i < 1; i += 0.25 )
	{
		var x = border;
		var y = border + i * (c2d.canvas.height - border);
		
		// Draw the text
		c2d.fillStyle = "black";
		c2d.font = "10px Times Roman";
		c2d.fillText(parseInt(y_max * (1 - parseInt(y - border)/c2d.canvas.height)), x - border, y + 5);

		// Draw the line
		c2d.beginPath();
		c2d.lineWidth = 2;
		c2d.strokeStyle = "rgba(0, 0, 0, 0.3)";
		c2d.moveTo(x, y);
		c2d.lineTo(c2d.canvas.width - border, y);
		c2d.stroke();
	}
		
}

function plot_data(c2d, x_data, x_max, y_data, y_max, color, border)
{
	// Set up a array of x, y coords so that when we start drawing
	// data we know the last position that we drew at
	var position = [-1, -1];


	var x_increment = ((c2d.canvas.width - (border * 2)) / x_data.length)
	for( var i = 0; i < x_data.length; i += 1 )
	{
		if( y_data[i] == -1 )
		{
			continue;
		}

		var x = x_data[i] * x_increment;
		var y = border + ((c2d.canvas.height - border) / y_max) * (y_max - y_data[i]);

		// If the position contains a -1 then this is the first plot for
		// the data
		if( position[0] == -1 )
		{
			position = [x, y];
		}

		// Draw a line joing the data points
		c2d.beginPath();
		c2d.strokeStyle = color;
		c2d.lineWidth = 2;
		c2d.moveTo(position[0], position[1]);
		c2d.lineTo(x, y);

		// Draw a circle at the new data point
		c2d.arc(x, y, 2, 0, 2 * Math.PI, false);

		// Draw to the canvas
		c2d.stroke();

		position = [x, y];
	}
}

///////////////////////
// Utility Functions //
///////////////////////

function get_max(data_set)
{
	var max_val = 0;

	for( var i = 0; i < data_set.length; i += 1 )
	{
		if( data_set[i] > max_val )
		{
			max_val = data_set[i];
		}
	}	

	return max_val;
}
