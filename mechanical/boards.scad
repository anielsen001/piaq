pi_pcb_thick = 1.6; 
pi_x = 65.0; 
pi_y = 30.0; 
pi_thru_hole_offset = 3.5; 

pm25_x = 21.5; 
pm25_y = 38.25;
pm25_z = 51.1; 

inch2mm = 25.4;

/* 
 * define pi zero dims 
   https://www.raspberrypi.org/documentation/hardware/raspberrypi/mechanical/README.md   
   holes are for M2.5
 * 
 */
module board_pi_zero_w(){
    x = pi_x; 
    y = pi_y;
    z = pi_pcb_thick;  // pcb thickness
    
    
    difference() {
    color("green") cube([x,y,z]); // primary board
    pi_zero_thru_holes(x,y,z);
    }
    board_pi_zero_sdcard();
    board_pi_zero_usb_pwr();
}

module pi_zero_thru_holes(x,y,z){
    
        thru_hole_diam = 2.5; 
        thru_hole_offset = pi_thru_hole_offset; // all hole centers are 3.5 mm from edges in both directions

        translate([thru_hole_offset, thru_hole_offset,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([x-thru_hole_offset, thru_hole_offset,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([thru_hole_offset, y-thru_hole_offset,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([x-thru_hole_offset, y-thru_hole_offset,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
}

module board_pi_zero_sdcard(){
    
    //pi_pcb_thick=1.6; 
    sd_card_center_offset=16.9;
    sd_card_x = 12.4;
    sd_card_y = 12.4; 
    sd_card_thick = 3;
    translate([0,sd_card_center_offset-sd_card_y/2,pi_pcb_thick])
        cube([sd_card_x,sd_card_y,sd_card_thick]);
}

module board_pi_zero_usb_pwr(){
    usb_offset = 54;
    usb_width = 8.2;
    usb_thick = 3.25; 
    //pi_pcb_thick=1.6; 
    translate([usb_offset-usb_width/2,0,pi_pcb_thick])
        cube([usb_width,usb_width,usb_thick]);
    
}

/* this is the CO2 sensor SDC30
 * other boards stack on it
 * https://learn.adafruit.com/adafruit-scd30/downloads
 */
module SCD30_board(){
    // original dimensions in inches
    x = 2.0*inch2mm;
    y = 1.0*inch2mm;
    z = 2.0; // mm not too critical
    
    // hole offsets are the same from each corner
    thru_hole_offset =  (1.0-0.8)/2 * inch2mm;
    thru_hole_diam = 2.5; 
    
    difference(){
        color("blue") cube([x,y,z]);
        translate([thru_hole_offset, thru_hole_offset,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([x-thru_hole_offset, thru_hole_offset,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([thru_hole_offset, y-thru_hole_offset,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([x-thru_hole_offset, y-thru_hole_offset,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
    }
}

/* this is the Plantower 2.5 particulate matter sensor
*/  
module plantower_pm25(){
    x = pm25_x;
    y = pm25_y;
    z = pm25_z;
    color("blue") cube([x,y,z]);
}

