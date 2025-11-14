// STEP EVENT


// Apply basic gravity
vel_y += grav_speed;

// Simple collision with ground
if (place_meeting(x, y + vel_y, obj_collision)) {
    while (!place_meeting(x, y + 1, obj_collision)) {
        y += 1;
    }
    vel_y = 0;
    grounded = true;
}

y += vel_y;