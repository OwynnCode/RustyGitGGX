//create event for obj_gArrow
// Arrow speed
speed_x = 8; // Speed for horizontal movement
speed_y = -0.7; // Increased upward velocity to help with arc and avoid floor

// Reduced gravity effect on the arrow for better trajectory
arrow_gravity = 0.05;

// Direction the arrow is facing (set by the enemy when firing)
// 1 for right, -1 for left
facing = 1;

// How long the arrow stays after hitting something (in steps/frames)
lifespan = 180; // 3 seconds at 60 FPS

// Whether the arrow has hit something and should stop moving
has_hit = false;

// Damage the arrow deals to player
damage = 1;

// Set proper sprite based on direction
if (facing == 1) { // Right
    sprite_index = gArrowRight;
} else { // Left
    sprite_index = gArrowLeft;
}

// Make arrow much smaller (reduced to 15% of original size)
image_xscale = 0.15;
image_yscale = 0.15;

// Keep arrows horizontal
image_angle = 0;

// Track flight time for gravity application delay
flight_time = 0;