use <rail.scad>;
use <truck.scad>;
use <support_block.scad>;

include <MCAD/materials.scad>

inch = 25.4;

plate_width=200;
plate_length=300;
plate_thickness=1/4*inch;
rail_width=34; //get this from rail.scad ... sigh.
rail_center_height=20.46; //this too
truck_length=36;  //sigh. is introspection too much to ask?
block_thickness=16; //got this value from support_block.scad
bearing_thickness=10; //made up
nut_thickness=5; //made up

//trucks can overlap with small inter-rail distance; 
//truck minimum spacing should allow third truck between 
y_carriage_width = max(plate_length/2, truck_length*3+2);
x_carriage_width = max(plate_width/2, truck_length*3+2);

module slide(length, carriage_length, trucks=2){union(){
    rail(length);
    if (trucks == 2) { union(){
        translate([0, rail_center_height, truck_length/2]) truck();
        translate([0, rail_center_height, carriage_length-truck_length/2]) truck();}}
    else if (trucks ==1) { translate([0, rail_center_height, carriage_length/2]) truck();}
}
}

module leadscrew_assembly(){
    %color(Aluminum) support_block();
    x=56.4; //cube size, not accurate
    shaft_length=25;
    coupler_length=15;
    threaded_length = plate_width - shaft_length - x - block_thickness - bearing_thickness - 10;
    translate([x/2,0,plate_width]) rotate([0,180,0]) union(){
        color(Stainless) cube(x,x,x);//stepper motor
        translate([x/2, x/2, x]) union(){
            color(Steel) cylinder(r=2.5, h=shaft_length); //stepper shaft
            translate([0,0,shaft_length-coupler_length/2]) color(Aluminum) cylinder(r=12/2, h=coupler_length); //helical coupler, fake numbers
            translate([0,0,shaft_length]) union(){//leadscrew
                translate([0,0,10]) color(Stainless) cylinder(r=(3/8)*inch/2, h=threaded_length);//threaded portion
                color(Steel) cylinder(r=5/2, h=10); //machined leadscrew end (stepper end)
                translate([0,0,threaded_length+10]) color(Steel) cylinder(r=5/2, h=2*bearing_thickness+block_thickness+nut_thickness); //machined leadscrew end (bearing end)
                translate([0,0,threaded_length+10]) cylinder(r=10,h=bearing_thickness);//thrust bearing
                %translate([0,0,threaded_length+10+block_thickness+bearing_thickness]) cylinder(r=10,h=bearing_thickness);//thrust bearing

            }

        }

    
    }
    translate([-x/2,0,plate_width-x]) rotate(a=[0,90,0]) 
        color(Aluminum) render() difference(){
            linear_extrude(height=x){ //motor bracket
                union(){
                    square([10,x]);
                    square([x,10]);    
                }
            }
            rotate(a=[0,90,0]) translate([-x/2, x/2, -5]) cylinder(r=10, h=20); //hole in bracket for motor shaft
    }

}

module xy_table() union(){
    cube([plate_width, plate_length, plate_thickness]);   
    union(){//x axis
        translate([0,plate_length/2,0]) rotate(a=[90,180,90]) leadscrew_assembly();
        translate([0, rail_width/2, 0]) rotate(a=[90,180,90]) slide(plate_width, x_carriage_width, trucks=1);
        translate([0, plate_length-rail_width/2, 0]) rotate(a=[90,180,90]) slide(plate_width, x_carriage_width);
    }
    union(){//y axis
        translate([rail_width/2, plate_length, plate_thickness]) rotate(a=[90,0,0]) slide(plate_length, y_carriage_width, trucks=1);
        translate([plate_width-rail_width/2, plate_length, plate_thickness]) rotate(a=[90,0,0]) slide(plate_length, y_carriage_width);
    }


translate([0,0,0]) for (i = [0:1]){
}


}xy_table();
