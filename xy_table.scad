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
    color(Aluminum) support_block();
    x=50; //cube size, not accurate
    shaft_length=25;
    coupler_length=15;
    translate([x/2,0,plate_width]) rotate([0,180,0]) union(){
        color(Stainless) cube(x,x,x);//stepper motor
        translate([x/2, x/2, x]) union(){
            cylinder(r=2.5, h=shaft_length); //stepper shaft
            translate([0,0,shaft_length-coupler_length/2]) color(Aluminum) cylinder(r=12/2, h=coupler_length); //helical coupler, fake numbers

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
