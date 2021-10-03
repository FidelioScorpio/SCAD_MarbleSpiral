use<marble_crosssection.scad>;
use<items.scad>;

start = -2;
$fn = 96;

difference()
{
    placement();
    color("pink") translate([0,0,-2]) tubePiece_cutout(40);
    translate([-15,-15,start-15]) cube([30,30,15]);
}
difference()
{
    union()
    {
        translate([0,0,start]) tallTubePiece(3);
    }
    translate([0,0,16]) rotate([0,90,105]) cylinder(h=20, d=20);
    translate([0,0,20]) rotate([0,90,125]) cylinder(h=20, d=20);
    translate([0,0,18]) rotate([0,90,114]) cylinder(h=20, d=20);
    
    translate([0,0,80]) rotate([0,90,250]) cylinder(h=20, d=20);
    translate([0,0,78]) rotate([0,90,240]) cylinder(h=20, d=20);
    translate([0,0,74]) rotate([0,90,220]) cylinder(h=20, d=15);
}

color("yellow") difference()
{
    union()
    {
        for (i=[0:5:90])
        {
            translate([0,0,74+14.3]) rotate([i,0,0]) translate([0,0,-14]) run_crosssection(1.5,1.5);
        }
        
        translate([0,0,72-6]) cylinder(h=8, d1=27, d2=4);
    }
    translate([0,0,72-6.5]) cylinder(h=8, d1=27, d2=2);
    
    translate([0,0,74]) difference()
    {
        cylinder(h=33.7,d=27.4+5, $fn=90);
        cylinder(h=33.7,d=27.4, $fn=90);
    }
}
 


echo("hello world");

// -There is a lump in the bottom of the top channel
// -There is a small lump in the right wall at the bottom
// -None of the polygons worked?!
// Internal cone thing needs to be more
// -Bottom left of the wall needs to be slightly wider

//Make sure there are no top points to the circle holes...

