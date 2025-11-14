//begin step event
// We still want gravity, but no movement
grounded = check_collision(0, 1);
if (grounded) {
    grounded_x = x;
    grounded_y = y;
    vel_y = 0; // Stop vertical movement when on ground
}
vel_y += grav_speed;