hole_spacing=50;
hole_d=4;

include <e3d.scad>;
screw_d=4;
head_bot_h=3.68+wiggle-2;
head_max_d=max(head_top_d,head_mid_d,head_bot_d);

module holes_2d()
{
	translate([-hole_spacing/2,0])
		circle(d=hole_d);
	translate([hole_spacing/2,0])
		circle(d=hole_d);
	circle(d=head_max_d);
}

module platform_2d()
{
	offset(5)
		hull()
			holes_2d();
}

module bracket_2d()
{
	difference()
	{
		platform_2d();
		translate([0,head_max_d/2,0])
			square(size=[head_max_d,head_max_d],center=true);
	}
}

module bracket_3d()
{
	linear_extrude(height=head_bot_h)
		difference()
		{
			bracket_2d();
			holes_2d();
		}
	jhead(4);
}

module retainer_3d()
{
	difference()
	{
		jhead(4);
		translate([0,0,-sigma])
			linear_extrude(height=head_bot_h+sigma*2)
				platform_2d();
	}
}


//A
bracket_3d();

//B
translate([0,1,1])
	rotate([0,0,180])
		retainer_3d();