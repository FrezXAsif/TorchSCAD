/*
  ========================================================
  SMART TORCH ENCLOSURE - V10 (FIXED BOSSES & SUPPORTS)
  ========================================================
*/

export_part = "both";            // "front", "back", or "both"
show_assembly_view = true;       // Shows the internal hardware
show_esp32 = false;               // Set to false to see the Mic/OLED clearly
show_sim = true;                 // Set to false to see the Antenna clearly

// --- CORE DIMENSIONS ---
W = 52;       
D = 48;       
H = 175;      
wall = 3;     
rad = 8;      
$fn = 60;     

if (export_part == "both") {
    translate([-35, 0, 0]) front_half();
    translate([35, 0, 0]) back_half();
    if (show_assembly_view) {
        translate([-35, 0, 0]) front_hardware();
        translate([35, 0, 0]) back_hardware();
    }
} else if (export_part == "front") { front_half(); } 
else if (export_part == "back") { back_half(); }

// ==========================================
// 1. HARDWARE VISUALIZER
// ==========================================
module front_hardware() {
    color("cyan") translate([W/2, 4, 110]) cube([28, 4, 28], center=true); // OLED
    translate([W/2, 4, 35]) rotate([90,0,0]) { // Speaker
        color("white") cylinder(d=18, h=5, center=true);
        color("black") translate([0,0,0.1]) cylinder(d=16, h=5.2, center=true);
    }
    color("black") translate([W/2 + 15, 4, 142]) rotate([90,0,0]) cylinder(d=14, h=2, center=true); // Round Mic
    if (show_esp32) {
        color("black") translate([W/2, 13, 110]) cube([29, 3, 52], center=true); // ESP32
    }
}

module back_hardware() {
    color("grey") translate([W/2, D/2 + 9, 45]) cylinder(d=18, h=65, center=true); // Battery
    color("blue") translate([W/2, D/2 - 2, wall + 2.5]) cube([17, 10, 5], center=true); // TP4056
    
    if (show_sim) {
        color("green") translate([W/2, D/2 + 10, 110]) cube([32, 3, 45], center=true); // SIM
    }
    // FLAT ANTENNA LOCATION (Visible dark green strip on the side wall)
    color("darkgreen") translate([W - wall - 1, D/2, 110]) cube([1, 15, 40], center=true); 

    color("white", 0.3) translate([W/2, D/2, 156]) rotate([180,0,0]) cylinder(d1=40, d2=13, h=32); // Reflector Cone
    color("white", 0.6) translate([W/2, D/2, 173]) cylinder(d=40, h=2, center=true); // Top Glass
}

// ==========================================
// 2. BASE SHELL & CUTOUTS
// ==========================================
module rounded_box(x, y, z, r) {
    linear_extrude(height = z) translate([r, r, 0]) offset(r = r) square([x - 2*r, y - 2*r]);
}
module hollow_shell() {
    difference() {
        rounded_box(W, D, H, rad);
        translate([wall, wall, wall]) rounded_box(W - 2*wall, D - 2*wall, H - 2*wall, rad - 1);
    }
}

module all_cutouts() {
    translate([W/2, D/2, H - 2]) cylinder(d=40.5, h=5); // Glass Flush Mount
    translate([W/2 - 6, D/2 - 3, -1]) cube([12, 6, wall+5]); // USB-C
    translate([W/2 - 14, -1, 96]) cube([28, wall+5, 28]); // OLED
    translate([W/2 + 15, -1, 142]) rotate([-90, 0, 0]) cylinder(d=3, h=wall+5, $fn=20); // Mic
    
    // 4x COPPER TOUCH SENSOR PADS (Recessed squares with center wire holes)
    for (i = [0 : 3]) { 
        translate([W - 1, D/2, 125 - (i * 15)]) rotate([0, 90, 0]) {
            cube([10, 10, 5], center=true); // The recess for copper tape
            cylinder(d=2, h=wall+5, center=true); // The hole for the wire
        }
    }
    for (x = [-8 : 2 : 8]) { // Speaker Grill
        for (z = [-8 : 2 : 8]) {
            if (sqrt(x*x + z*z) <= 8.5) {
                translate([W/2 + x, -1, 35 + z]) rotate([-90, 0, 0]) cylinder(d=1.5, h=wall+5, $fn=12);
            }
        }
    }
}

// ==========================================
// 3. INTERNAL MODULE RESTRAINTS
// ==========================================
module board_rails_with_stops(board_w, y_center, z_start, h) {
    // Left Groove
    translate([W/2 - board_w/2 - 2, y_center - 2, z_start]) difference() {
        cube([4, 4, h]);
        translate([2, 1.2, -1]) cube([3, 1.6, h+2]); 
    }
    // Right Groove
    translate([W/2 + board_w/2 - 2, y_center - 2, z_start]) difference() {
        cube([4, 4, h]);
        translate([-1, 1.2, -1]) cube([3, 1.6, h+2]); 
    }
    // Solid Ledge (Floor for the board to sit on)
    translate([W/2 - board_w/2, y_center - 1, z_start - 3]) cube([board_w, 4, 3]);
    // Top Z-Stop
    translate([W/2 - board_w/2, y_center - 1, z_start + h]) cube([board_w, 2, 2]);
}

// Generic Thin Reflector Basket (Replaces the massive block)
module reflector_basket() {
    translate([W/2, D/2, 140]) difference() {
        cylinder(d1=17, d2=44, h=32); // Outer basket
        translate([0,0,-1]) cylinder(d1=13, d2=40.5, h=34); // Inner funnel
    }
}

// Aggressive Battery C-Clips
module battery_clip(z) {
    translate([W/2, D/2 + 9, z]) difference() {
        cylinder(d=24, h=10, center=true);
        cylinder(d=18.5, h=12, center=true); // Battery space
        translate([0, -10, 0]) cube([20, 20, 12], center=true); // Opening to snap it in
    }
}

// ==========================================
// 4. ASSEMBLY LOGIC WITH ANCHORED BOSSES
// ==========================================
module front_half() {
    union() { 
        difference() {
            hollow_shell();
            all_cutouts();
            translate([-5, D/2, -5]) cube([W+10, D+10, H+10]);
        }
        
        difference() { // Mid-Shelf
            translate([wall, wall, 80]) cube([W - 2*wall, D/2 - wall, 2]); 
            translate([W/2, D/2, 80]) cube([16, 10, 6], center=true); 
        }
        
        board_rails_with_stops(29, 13, 84, 52); // ESP32
        
        translate([W/2, wall + 0.5, 110]) rotate([90,0,0]) difference() { // OLED Frame
            cube([32, 32, 2], center=true);
            cube([28, 28, 4], center=true);
        }
        
        // Round Mic Bracket
        translate([W/2 + 15, wall + 2, 142]) rotate([90,0,0]) difference() {
            cube([18, 18, 4], center=true);
            cylinder(d=14.5, h=6, center=true);
            translate([0, 9, 0]) cube([14, 10, 6], center=true); // Top drop-in slot
        }
        reflector_basket();
        
        // ANCHORED FRONT BOSSES (Flush against left and right walls)
        translate([wall, D/2 - 7, 15]) difference() { cube([7, 7, 7]); translate([3.5, 7.1, 3.5]) rotate([90,0,0]) cylinder(d=2.8, h=10); }
        translate([W - wall - 7, D/2 - 7, 15]) difference() { cube([7, 7, 7]); translate([3.5, 7.1, 3.5]) rotate([90,0,0]) cylinder(d=2.8, h=10); }
        translate([wall, D/2 - 7, 130]) difference() { cube([7, 7, 7]); translate([3.5, 7.1, 3.5]) rotate([90,0,0]) cylinder(d=2.8, h=10); }
        translate([W - wall - 7, D/2 - 7, 130]) difference() { cube([7, 7, 7]); translate([3.5, 7.1, 3.5]) rotate([90,0,0]) cylinder(d=2.8, h=10); }
    }
}

module back_half() {
    difference() {
        union() { 
            difference() {
                hollow_shell();
                all_cutouts();
                translate([-5, -5, -5]) cube([W+10, D/2 + 5, H+10]);
            }
            difference() { // Mid-Shelf
                translate([wall, D/2, 80]) cube([W - 2*wall, D/2 - wall, 2]); 
                translate([W/2, D/2, 80]) cube([16, 10, 6], center=true); 
            }
            
            // TP4056 Box
            translate([W/2 - 9, D/2 - 8, wall]) difference() { cube([18, 16, 4]); translate([1, 1, -1]) cube([16, 16, 6]); }
            
            battery_clip(25);
            battery_clip(60);
            translate([W/2, D/2 + 9, 78]) cube([24, 14, 2], center=true); // Roof
            
            board_rails_with_stops(32, D/2 + 10, 87, 45); // SIM Module
            
            reflector_basket();
            
            // ANCHORED BACK BOSSES 
            translate([wall, D/2, 15]) cube([7, 7, 7]); 
            translate([W - wall - 7, D/2, 15]) cube([7, 7, 7]); 
            translate([wall, D/2, 130]) cube([7, 7, 7]); 
            translate([W - wall - 7, D/2, 130]) cube([7, 7, 7]); 
        }
        
        // M3 Holes through back wall and bosses
        translate([wall + 3.5, D+1, 18.5]) rotate([90,0,0]) cylinder(d=3.2, h=D);
        translate([W - wall - 3.5, D+1, 18.5]) rotate([90,0,0]) cylinder(d=3.2, h=D);
        translate([wall + 3.5, D+1, 133.5]) rotate([90,0,0]) cylinder(d=3.2, h=D);
        translate([W - wall - 3.5, D+1, 133.5]) rotate([90,0,0]) cylinder(d=3.2, h=D);
        
        // Countersinks
        translate([wall + 3.5, D+1, 18.5]) rotate([90,0,0]) cylinder(d=6.5, h=wall+2);
        translate([W - wall - 3.5, D+1, 18.5]) rotate([90,0,0]) cylinder(d=6.5, h=wall+2);
        translate([wall + 3.5, D+1, 133.5]) rotate([90,0,0]) cylinder(d=6.5, h=wall+2);
        translate([W - wall - 3.5, D+1, 133.5]) rotate([90,0,0]) cylinder(d=6.5, h=wall+2);
    }
}
