
// include the external boards for reference
include <boards.scad>;

pm25_offset_x = 32;
pm25_offset_y = 40;
pm25_rotate = 90;

pi_standoff_height=5;
pi_standoff_diam=3.5;

// basic base
module base(){
    x = 70; 
    y = 100; 
    z = 3;
    translate([-2.5,-2.5,-z])cube([x,y,z]);
    
    // the base needs a slot to hold the pm2.5 sensor
    // dimensions loaded from include file
    slot_height=10;
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
            translate([pi_thru_hole_offset/2, pi_thru_hole_offset/2,0])
              cylinder(r=pi_standoff_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_x-pi_thru_hole_offset/2, pi_thru_hole_offset/2,0])
              cylinder(r=pi_standoff_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_thru_hole_offset/2, pi_y-pi_thru_hole_offset/2,0])
              cylinder(r=pi_standoff_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_x-pi_thru_hole_offset/2, pi_y-pi_thru_hole_offset/2,0])
              cylinder(r=pi_standoff_diam/2,h=pi_standoff_height,$fn=16);
        }//end union
        union(){
            standoff_hole_diam=2.0;
            translate([pi_thru_hole_offset/2, pi_thru_hole_offset/2,0])
              cylinder(r=standoff_hole_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_x-pi_thru_hole_offset/2, pi_thru_hole_offset/2,0])
              cylinder(r=standoff_hole_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_thru_hole_offset/2, pi_y-pi_thru_hole_offset/2,0])
              cylinder(r=standoff_hole_diam/2,h=pi_standoff_height,$fn=16);
            translate([pi_x-pi_thru_hole_offset/2, pi_y-pi_thru_hole_offset/2,0])
              cylinder(r=pi_standoff_diam/2,h=pi_standoff_height,$fn=16);
        }//end union
    
    }//end  difference   
}


translate([0,0,pi_standoff_height])board_pi_zero_w();
translate([63,35,0])rotate([0,0,90]) SCD30_board();
translate([pm25_offset_x,pm25_offset_y,0]) rotate([0,0,pm25_rotate]) plantower_pm25();

base();