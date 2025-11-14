// Create Event for obj_arrow
// Arrow speed - increased for better distance
speed_x = 16; // Increased from 12
speed_y = -1; // Small initial upward velocity to help with arc
// Reduced gravity effect on the arrow - for flatter initial trajectory
arrow_gravity = 0.05; // Decreased from 0.08 for better distance
// Direction the arrow is facing (set by the player when firing)
// 1 for right, -1 for left
facing = 1;
// How long the arrow stays after hitting something (in steps/frames)
lifespan = 180; // 3 seconds at 60 FPS
// Whether the arrow has hit something and should stop moving
has_hit = false;
// Damage the arrow deals to enemies
damage = 1;
// List to track which enemies this arrow has already hit
hit_enemies = ds_list_create();
// Set proper sprite based on direction
if (facing == 1) { // Right
    sprite_index = sArrowRight;
} else { // Left
    sprite_index = sArrowLeft;
}

// Make arrow much smaller
image_xscale = 0.2;  // Even smaller
image_yscale = 0.2;

// Keep arrows horizontal
image_angle = 0;