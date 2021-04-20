
// include the external boards for reference
include <boards.scad>;

//pm25_offset_x = 32;
//pm25_offset_y = 40;
//pm25_rotate = 90;

pm25_offset_x = 0;
pm25_offset_y = 40;
pm25_rotate = 0;

pi_standoff_height=5.0;
pi_standoff_diam=5;

// basic base
module base(){
    x = 70; 
    y = 100; 
    z = 3;
    
    difference(){
    translate([-2.5,-2.5,-z])cube([x,y,z]);
    
    // add holes for SDC30 standoffs - 
    thru_hole_offset =  (1.0-0.8)/2 * inch2mm;
    thru_hole_diam = 2.5; 
    translate([63,35,-10])rotate([0,0,90])
        union(){
            x=2.0*inch2mm;
            y=1.0*inch2mm;
            z=-10.0;
    translate([thru_hole_offset, thru_hole_offset,0])
        cylinder(r=thru_hole_diam/2,h=200,$fn=16);
    translate([x-thru_hole_offset, thru_hole_offset,0])
        cylinder(r=thru_hole_diam/2,h=200,$fn=16);
    translate([thru_hole_offset, y-thru_hole_offset,0])
        cylinder(r=thru_hole_diam/2,h=200,$fn=16);
    translate([x-thru_hole_offset, y-thru_hole_offset,0])
        cylinder(r=thru_hole_diam/2,h=200,$fn=16);
        } //end union
    //} //end difference
           
       // this makes the pi mounting  holes thru holes 
       color("blue")      union(){
            standoff_hole_diam=2.0;
            translate([pi_thru_hole_offset, pi_thru_hole_offset,-100]) cylinder(r=standoff_hole_diam/2,h=200,$fn=16);
            translate([pi_x-pi_thru_hole_offset, pi_thru_hole_offset,-100])            cylinder(r=standoff_hole_diam/2,h=200,$fn=16);
            translate([pi_thru_hole_offset, pi_y-pi_thru_hole_offset,-100])            cylinder(r=standoff_hole_diam/2,h=200,$fn=16);
            translate([pi_x-pi_thru_hole_offset, pi_y-pi_thru_hole_offset,-100])           cylinder(r=standoff_hole_diam/2,h=200,$fn=16);
        }//end union       
        
            
    } //end difference
        
        
    // the base needs a slot to hold the pm2.5 sensor
    // dimensions loaded from include file
    slot_height=5.0;
    slot_width=5;
    slot_wall_thick=2.0;
    translate([pm25_offset_x+slot_width/2,pm25_offset_y-slot_width/2,0]) rotate([0,0,pm25_rotate])
    difference(){
    cube([pm25_x+slot_width,pm25_y+slot_width,slot_height]);
        translate([slot_wall_thick/2,slot_wall_thick/2,0])
        cube([pm25_x+slot_width-slot_wall_thick,pm25_y+slot_width-slot_wall_thick,slot_height]);
    }
    
    // create standoffs for the raspberry pi
    difference(){
        union(){
            translate([pi_thru_hole_offset,      pi_thru_hole_offset,0]) cylinder(r=pi_standoff_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_x-pi_thru_hole_offset, pi_thru_hole_offset,0]) cylinder(r=pi_standoff_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_thru_hole_offset,      pi_y-pi_thru_hole_offset,0]) cylinder(r=pi_standoff_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_x-pi_thru_hole_offset, pi_y-pi_thru_hole_offset,0]) cylinder(r=pi_standoff_diam/2,h=pi_standoff_height,$fn=16);
        }//end union
        union(){
            standoff_hole_diam=2.0;
            translate([pi_thru_hole_offset, pi_thru_hole_offset,0])
                cylinder(r=standoff_hole_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_x-pi_thru_hole_offset, pi_thru_hole_offset,0])            cylinder(r=standoff_hole_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_thru_hole_offset, pi_y-pi_thru_hole_offset,0])            cylinder(r=standoff_hole_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_x-pi_thru_hole_offset, pi_y-pi_thru_hole_offset,0])           cylinder(r=standoff_hole_diam/2,h=pi_standoff_height,$fn=16);
        }//end union
    
    }//end  difference   
    
    // add edge rim to hold top in place
    edge_rim_thick = 2.0;
    edge_rim_gap = 1.0;
    edge_rim_height = 5.0;
    translate([-2.5,-2.5,0])
    translate([edge_rim_gap,edge_rim_gap,0])
    
    difference(){
        cube([x-edge_rim_gap*2,y-edge_rim_gap*2,edge_rim_height]);
        translate([edge_rim_gap,edge_rim_gap,0])cube([x-edge_rim_gap*2-edge_rim_thick,y-edge_rim_gap*2-edge_rim_thick,edge_rim_height]);  
    }
    

}



//translate([0,0,pi_standoff_height])board_pi_zero_w();
//translate([63,35,0])rotate([0,0,90]) SCD30_board();
//translate([pm25_offset_x,pm25_offset_y,0]) rotate([0,0,pm25_rotate]) plantower_pm25();

base();