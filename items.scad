module rod(d_reduce) {cylinder(h=10-d_reduce, d=3-d_reduce);}

module marbleHalves()
{
    difference()
    {
        union()
        {
            sphere(d=14.6);
            translate([15,0,0]) sphere(d=14.6);
        }
        translate([0,0,-15]) cube([50,50,30], center=true);
        translate([0,0,-5]) rod(0);
        translate([15,0,-5]) rod(0);
    }
}

tubePieceHeight = 33.7+6;
tubePieceHeight_stack = 33.7;
tubePieceHeight_top = tubePieceHeight_stack+6;

_tubePieceMainCutout = 24; // was 23.9
_tubePieceLip = 23.55; // lip cylinder works at 23.5, snug at 23.6

module marble()
{
    sphere(d=14.6);
}

module tubePiece()
{
    difference()
    {
        union()
        {
            difference()
            {
                cylinder(h=33.7,d=27.4); //main cylinder
                translate([0,0,-0.4]) cylinder(h=31.7, d=_tubePieceMainCutout); // main cutout
            }
        
            translate([0,0,33.7-6]) cylinder(h=12, d=_tubePieceLip); //lip cylinder works at 23.5, snug at 23.6
            
            translate([0,0,33.7-6]) cylinder(h=5, d=_tubePieceMainCutout); // extra padding
        }
        translate([0,0,-1]) cylinder(h=45,d=19.1); //lip cutout
        
        translate([0,0,33.7-6.1]) cylinder(h=7, d2=19.1, d1=_tubePieceMainCutout); // slope from main to lip
    }
}
module tallTubePiece(numTubes)
{
    difference()
    {
        union()
        {
            difference()
            {
                cylinder(h=33.7*numTubes,d=27.4); //main cylinder
                translate([0,0,-0.4]) cylinder(h=(33.7*numTubes) - 2, d=_tubePieceMainCutout); // main cutout
            }
        
            translate([0,0,(33.7*numTubes)-6]) cylinder(h=12, d=_tubePieceLip); //lip cylinder
            
            translate([0,0,(33.7*numTubes)-6]) cylinder(h=5, d=_tubePieceMainCutout); // extra padding
        }
        translate([0,0,-1]) cylinder(h=33.7*numTubes + 8,d=19.1); //lip cutout (h was 45)
        
        translate([0,0,(33.7*numTubes)-6.1]) cylinder(h=7, d2=19.1, d1=_tubePieceMainCutout); // slope from main to lip
    }
}
module tubePiece_cutout(height)
{
    cylinder(h=height, d=_tubePieceMainCutout); // main cutout
}
module bottomedTubePiece()
{
    tubePiece();
    cylinder(h=23,d=27.4); //add bottom to main cylinder
}