function HSBtoRGB(h, s, l)
{
	var C = (1 - Math.abs(2 * l - 1)) * s;
	var Hp = h/60.0;
	var x = C * ( 1 - Math.abs(Hp%2 - 1));

	var r;
	var g;
	var b;

	if( Hp >= 0 && Hp < 1 )
	{
		r = C;
		g = x;
		b = 0;
	}
	else if( Hp >= 1 && Hp < 2 )
	{
		r = x;
		g = C;
		b = 0;
	}
	else if( Hp >= 2 && Hp < 3 )
	{
		r = 0;
		g = C;
		b = x;
	}
	else if( Hp >= 3 && Hp < 4 )
	{
		r = 0;
		g = x;
		b = C;
	}
	else if( Hp >= 4 && Hp < 5 )
	{
		r = x;
		g = 0;
		b = C;
	}	
	else if( Hp >= 5 && Hp < 6 )
	{
		r = C;
		g = 0;
		b = x;
	}

	m = l - (1/2.0) * C;

	return [255 * (r+m), 255 * (g+m), 255 * (b+m)];
}
