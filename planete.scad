module planete() {
    difference() {
        union() {
// Surface (par intersection de cube tournants)
            intersection_for(i=[1:180]) {
                rotate([i,i*i,i*i*i])
                cube([200,200,200],center=true);
            }

// Volcans    
            for (i=[0:10]) {
                rotate(rands(0,360,3,i*1000)) translate([0,0,98]) scale(rands(.75,1.25,1,i*1000+1)[0]) volcan();
            }

// Des maisons
            for (i=[0:100]) {
                rotate(rands(0,360,3,i*0.1)) translate([0,0,100]) house();
            }

// Des Empires...
            rotate([45,-5,70]) desEmpires(210);

        }
// Évidement intérieur        
        sphere(d=196);
        
// Cone de fixation aux pôles
        for(i=[-1,1]) {
            translate([0,0,i*96]) rotate([i*90+90,0,0]) cylinder(d1=10, d2=0, h=10, $fn=60, center=true);
        }
    }
}

module decouper(d=1, bloc=0) {
    y = [1];
    x = [0];
    
    for (i=y, a=x) translate([d/2*sqrt(2)*cos(a*90+45),d/2*sqrt(2)*sin(a*90+45),d/2*i]) {
        intersection() {
            planete();
            rotate([0,0,a*90]) translate([100,100,i*100]) cube([200,200,200], center=true);
        }
        
    // Lèvre centrale / horizontale
        if (i == -1) intersection() {
            difference() {
                union() {
                    cylinder(d=196,h=10,center=true);
                    translate([0,0,-2.5]) cylinder(d=197,h=5,center=true);
                }
                cylinder(d=192,h=11,center=true);
            }
            rotate([0,0,a*90]) translate([100,100,i*0]) cube([200,200,20], center=true);
        }


    // Lèvre verticale    
        rotate([i*90,0,90*a]) intersection() {
            difference() {
                union() {
                    cylinder(d=196,h=10,center=true);
                    translate([0,0,-2.5]) cylinder(d=197,h=5,center=true);
                }
                cylinder(d=192,h=11,center=true);
            }
            translate([100,100,0]) cube([200-15,200-15,20], center=true);
        }
    }
}

module house() {
    scale(0.5) translate([0,0,10]) union() {
        translate([0,0,-5]) cube(12, center=true);

        intersection() {
            rotate([45,0,0]) cube(15, center=true);
            translate([0,0,15]) cube(30, center=true);
        }
    }
}

module volcan() {
    difference() {
        rotate_extrude($fn=10/*60*/) {
            polygon([[0,0],
                for (i=[0:20]) [i,25*exp(-(i*i/100))]
            ]);
        }
        for (i=[0:5]) {
            rotate([0,0,i*12]) cylinder(d=rands(8,12,1,i*100)[0], h=25, $fn=3);
        }
    }
}

module desEmpires(diam = 200) {
    union() intersection() {
        pas = 10;
        sphere(d= diam, $fn=60);
        for (i=[0:pas:150]) {
            rotate([0,0,i-pas/2]) intersection() {
                rotate_extrude(angle=pas) translate([0,-diam/2-50,0]) square([diam/2+50,1.5*diam]);
                rotate([90,0,90+pas/2]) linear_extrude(height=diam) translate([-i*PI*diam/360,0,0]) text("des Empires...", font = "Liberation Sans", size=30, valign="center");
            }
        }
    }
}


decouper();
