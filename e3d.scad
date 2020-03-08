wiggle=0.25;
head_top_d=16+wiggle;
head_top_h=3+wiggle;
head_mid_d=12+wiggle;
head_mid_h=6-wiggle;
head_bot_d=16+wiggle;
head_bot_h=3.68+wiggle;
wall=2;
case_height=head_bot_h+head_mid_h+head_top_h;
case_size=head_top_d+wall*2;
sigma=0.01;
screw_d=3.5;
$fn=100;
screw_spacing=24;
screw_wall=3;

module head()
{
	union()
	{
		translate([0,0,head_bot_h+head_mid_h])
			cylinder(d=head_top_d,h=head_top_h+sigma);
		translate([0,0,-sigma])
			cylinder(d=head_mid_d,h=head_bot_h+head_mid_h+head_top_h+sigma*2);
		translate([0,0,-sigma])
			cylinder(d=head_bot_d,h=head_bot_h+sigma);
	}
}

module screws_2d()
{
	translate([-screw_spacing/2,0,0])
		circle(d=screw_d);
	translate([screw_spacing/2,0,0])
		circle(d=screw_d);
}

module rib_2d()
{
	difference()
	{
		hull()
		{
			square([case_size,case_height],center=true);
			offset(screw_wall)
				screws_2d();
			translate([0,-case_height/4])
				square([screw_spacing+screw_d+screw_wall*2,case_height/2],center=true);
		}
		screws_2d();
	}
}

module center_rib(rib_width)
{
	translate([0,rib_width,0])
		rotate([90,0,0])
			linear_extrude(height=rib_width*2)
				rib_2d();
}

module case(rib_width=2)
{
	translate([0,0,case_height/2])
		union()
		{
			center_rib(rib_width);
			cylinder(d=case_size,h=case_height,center=true);
		}
}

module jhead(rib_width=2,side=-1)
{
	intersection()
	{
		difference()
		{
			case(rib_width);
			head();
		}
		translate([0,case_size/4*side,case_height/2])
			cube(size=[screw_spacing+screw_d+screw_wall*2,case_size/2,case_height],center=true);
	}
}