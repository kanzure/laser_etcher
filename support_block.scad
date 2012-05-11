//vxb rail support block
//http://www.vxb.com/page/bearings/PROD/kit7136

module support_block(){
    D=16;
    h=27;
    E=24;
    W=48;
    L=16;
    F=44;
    G=6;
    P=25;
    B=38;
    S=5.5;
    locking_bolt=4; //M4
    clamping_bolt=5; //M5

    linear_extrude(height=L){
        difference(){
            union(){
                translate([-W/2,0]) square([W,G]);
                translate([-P/2,0]) square([P,F]);
            }
                translate([0,h]) circle(r=D/2);
        }
    }
}
support_block();
