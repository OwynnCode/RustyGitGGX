// Add this to the obj_dummy create event
event_inherited();

// Make sure this enemy doesn't move
vel_x = 0;
vel_y = 0;
move_speed = 0;
friction_power = 0;

// This enemy doesn't deal damage
damage = 0;

// Identify this as a dummy for collision and attack handling
is_dummy = true;

// Variables for hit effect (flashing)
flash = false;
flash_duration = 10; // Frames the dummy will flash when hit
flash_timer = 0;
flash_alpha = 0.7; // Intensity of the white flash

// Sprite setup 
sprite_index = sDummy; // Make sure to create a dummy sprite or use a placeholder
image_speed = 0;       // No animation

// Set to infinite health
hp = 999999;

// Variable to handle hit detection
has_been_hit = false;

