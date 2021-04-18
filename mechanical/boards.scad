pi_pcb_thick = 1.6; 

inch2mm = 25.4;

/* 
 * define pi zero dims 
   https://www.raspberrypi.org/documentation/hardware/raspberrypi/mechanical/README.md   
   holes are for M2.5
 * 
 */
module board_pi_zero_w(){
    x = 65.0; 
    y = 30.0;
    z = pi_pcb_thick;  // pcb thickness
    
    thru_hole_diam = 2.5; 
    thru_hole_offset = 3.5; // all holes are 3.5 mm from edges in both directions
    
    difference() {
    color("green") cube([x,y,z]); // primary board
        translate([thru_hole_offset/2, thru_hole_offset/2,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([x-thru_hole_offset/2, thru_hole_offset/2,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([thru_hole_offset/2, y-thru_hole_offset/2,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([x-thru_hole_offset/2, y-thru_hole_offset/2,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
    }
    board_pi_zero_sdcard();
    board_pi_zero_usb_pwr();
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
    z = 2.0; // not too critical
    
    // hole offsets are the same from each corner
    thru_hole_offset =  (1.0-0.8)/2 * inch2mm;
    thru_hole_diam = 2.5; 
    
    difference(){
        color("blue") cube([x,y,z]);
        translate([thru_hole_offset/2, thru_hole_offset/2,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([x-thru_hole_offset/2, thru_hole_offset/2,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([thru_hole_offset/2, y-thru_hole_offset/2,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
        translate([x-thru_hole_offset/2, y-thru_hole_offset/2,0])
            cylinder(r=thru_hole_diam/2,h=10,$fn=16);
    }
}

/* this is the Plantower 2.5 particulate matter sensor
*/  
module plantower_pm25(){
    x = 21.15;
    y = 30.8;
    z = 50.025;
    color("blue") cube([x,y,z]);
}

board_pi_zero_w();
translate([60,35,0])rotate([0,0,90]) SCD30_board();
translate([31,40,0]) rotate([0,0,90]) plantower_pm25();