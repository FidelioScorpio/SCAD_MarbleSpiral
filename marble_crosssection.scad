
$fn = 180;
allowedMarbleWidth = 18;
runWallThickness = 2;
runOuterWidth = allowedMarbleWidth + 2*runWallThickness;
runInnerWidth = allowedMarbleWidth;
fractionOfMarbleIsRun = 1/6;
runCutHeight = runInnerWidth*fractionOfMarbleIsRun;
tubePieceHeight_Each = 33.7;
tubePieceHeight_Cap = 6;
tubeDiameter = 30; //was 27.4
tubeCutoutDiameter = 23.3;



module run_crosssection(cut_a, cut_b, poly_bool)
{
    module basic(height, lump)
    {
        color("white") union()
        {
            difference()
            {
                union()
                {
                    cylinder(h=height,d=runOuterWidth); // main cylinder
                    if (lump)
                    {
                        translate([-runOuterWidth/2,-runOuterWidth,0]) cube([runOuterWidth/2,runOuterWidth,height]); // cube for the slope
                    }
                }
                translate([0,0,-0.5]) 
                  cylinder(h=height+1,d=runInnerWidth); // marble run cutout
                translate([-(runOuterWidth/2)-0.5,runCutHeight,-0.5])
                  cube([runOuterWidth*2, runInnerWidth,height+1]); // open-top cutoff
                  
                if (lump)
                {
                translate([-runOuterWidth/2,-runOuterWidth,-0.1]) rotate(-45) 
                  cube([runOuterWidth/2,sqrt(2*pow(runOuterWidth/2,2)),height+0.2]); // cut for the slope
                }
            }
            centreWall = (allowedMarbleWidth + runWallThickness) / 2;
            dist = sqrt(pow(runOuterWidth/2,2) - pow(runCutHeight,2));
            endstop = dist - runWallThickness/2;

            translate([-endstop, (allowedMarbleWidth*fractionOfMarbleIsRun), 0])
              cylinder(h=height, d=runWallThickness + 0.5); // Left ball tip
            translate([endstop, (allowedMarbleWidth*fractionOfMarbleIsRun), 0])
              cylinder(h=height, d=runWallThickness + 0.5); // Right ball tip
        }
    }
    rotate([90,0,0]) 
    translate([0,allowedMarbleWidth/2 + runWallThickness/2,-max(cut_a, cut_b)/2])
    union()
    {
    
        faces_x = [[0,1,2,3],[1,2,5,4],[0,3,5,4],[0,4,1],[5,2,3]];
        if (cut_a == cut_b)
        {
            basic(cut_a, poly_bool);
        }
        else
        {
            difference()
            {
                basic(max(cut_a, cut_b), poly_bool);
                x_start = -runOuterWidth/2 - 0.1;
                y_start = -(runOuterWidth) - 0.1;
                xy_end = runOuterWidth/2 + 0.1;
                z_bottom = -0.1;
                faces = [[0,1,3,2],[2,3,5,4],[0,4,5,1],[0,2,4],[1,5,3]];
                if (cut_a < cut_b)
                {
                    z_top = cut_b + 0.1;
                    upper_z = cut_b/2 + cut_a/2;
                    lower_z = cut_b/2 - cut_a/2;
                    // Two polyhedrons =  
                    //  AB.-----------------.CD 
                    //    |                       
                    //    |                       
                    //  EF.                       
                    //                            
                    //                      
                    //  AB.                 
                    //    |                 
                    //    |                 
                    //  EF.-----------------.CD
                    poly_a = [
                    [x_start, y_start, z_top], // A
                    [x_start, xy_end, z_top], // B
                    [xy_end, y_start, z_top], // C
                    [xy_end, xy_end, z_top], // D
                    [x_start, y_start, upper_z], // E
                    [x_start, xy_end, upper_z]  // F
                    ];
                    poly_b = [
                    [x_start, y_start, lower_z], // A
                    [x_start, xy_end, lower_z], // B
                    [xy_end, y_start, z_bottom], // C
                    [xy_end, xy_end, z_bottom], // D
                    [x_start, y_start, z_bottom], // E
                    [x_start, xy_end, z_bottom]  // F
                    ];
                    color("green") polyhedron(poly_a, faces);
                    color("green") polyhedron(poly_b, faces);
                }
                else if (cut_b < cut_a)
                {
                    z_top = cut_a + 0.1;
                    upper_z = cut_a/2 + cut_b/2;
                    lower_z = cut_a/2 - cut_b/2;
                    // Two polyhedrons =  
                    //  AB.-----------------.CD 
                    //                      |     
                    //                      |     
                    //                      .EF   
                    //                            
                    //                      
                    //                      .AB
                    //                      |  
                    //                      |  
                    //  EF.-----------------.CD
                    
                    poly_a = [
                    [x_start, y_start, z_top], // A
                    [x_start, xy_end, z_top], // B
                    [xy_end, y_start, z_top], // C
                    [xy_end, xy_end, z_top], // D
                    [xy_end, y_start, upper_z], // E
                    [xy_end, xy_end, upper_z]  // F
                    ];
                    poly_b = [
                    [xy_end, y_start, lower_z], // A
                    [xy_end, xy_end, lower_z], // B
                    [xy_end, y_start, z_bottom], // C
                    [xy_end, xy_end, z_bottom], // D
                    [x_start, y_start, z_bottom], // E
                    [x_start, xy_end, z_bottom]  // F
                    ];
                    polyhedron(poly_a, faces);
                    polyhedron(poly_b, faces);
                }
            }
        }
    }
}
module cutout(height)
{
    cylinder(h=height+1,d=runOuterWidth);
}
module placement()
{
    tubes = 2;
    num_rotations = 1.5;
    z_step = 0.15;
    phase2 = ((tubes - 0.5165)*tubePieceHeight_Each) + tubePieceHeight_Cap;
    theta_delta = (num_rotations*360)/(phase2);
    phase1 = 180/theta_delta; // theta_delta*phase1 = 180
    phase3 = phase2 + 180/theta_delta;
    echo("phase1", phase1, "phase2", phase2, "phase3", phase3);
    counter = 0;
    phase1_frac = phase1 / phase3;
    phase2_frac = (phase2-phase1) / phase3;
    phase3_frac = (phase3-phase2) / phase3;
    
    total_steps = phase3/z_step;
    phase1_steps = phase1_frac * total_steps;
    phase2_steps = phase2_frac * total_steps;
    phase3_steps = phase3_frac * total_steps;
    p2num_pieces = (phase2_steps/num_rotations);
    echo("phase2_steps", phase2_steps);
    echo("phase2 height", phase2-phase1);
    
    echo(p2num_pieces);
    
    //phase2 theta_delta start = theta_delta*phase2
    //theta_delta*0 -> theta_delta*phase2 needs to be 180 degrees
    // what does bottom do to this?
        
    for(counter = [0:z_step:phase3])
    {
        //Entry
        if (counter < phase1)
        {
            z = counter;
            r = (tubeDiameter + allowedMarbleWidth) / 2;
            x = ((r * cos(theta_delta*counter)) / 2) - r / 2;
            y = ((r * sin(theta_delta*counter)) / 2);
            inner = (2 * PI * (tubeDiameter/2)) / p2num_pieces;
            outer = (2 * PI * ((tubeDiameter/2) + allowedMarbleWidth)) / p2num_pieces;
            color("orange") translate([x,y,z]) rotate(theta_delta*counter) run_crosssection(inner,outer, 1);
        }
        //Central
        else if (counter < phase2)
        {
            // radius = tube_r + pipe_w/2
            // inner = (2 * PI * tube_r) / num_pieces
            // outer = (2 * PI * (tube_r + pipe_w)) / num_pieces
            z = counter;
            r = (tubeDiameter + allowedMarbleWidth) / 2;
            x = r * cos(theta_delta*counter);
            y = r * sin(theta_delta*counter);
            inner = (2 * PI * (tubeDiameter/2)) / p2num_pieces;
            outer = (2 * PI * ((tubeDiameter/2) + allowedMarbleWidth)) / p2num_pieces;
            // echo("r",r,"theta",theta_delta*counter,"x,y,z",[x,y,z]);
            //translate([x,y,z]) cube([1,1,1]);
            translate([x,y,z]) rotate(theta_delta*counter) run_crosssection(inner,outer, 1);
        }
        //Exit
        else if (counter < phase3)
        {
            z = counter;
            r = (tubeDiameter + allowedMarbleWidth) / 2;
            x = ((r * cos(theta_delta*counter)) / 2) - r / 2;
            y = ((r * sin(theta_delta*counter)) / 2);
            inner = (2 * PI * (tubeDiameter/2)) / p2num_pieces;
            outer = (2 * PI * ((tubeDiameter/2) + allowedMarbleWidth)) / p2num_pieces;
            color("orange") translate([x,y,z]) rotate(theta_delta*counter) run_crosssection(inner,outer, 1);
        }
    }
}

//run_crosssection(3,13);
placement();
