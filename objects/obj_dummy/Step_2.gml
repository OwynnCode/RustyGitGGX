// End Step Event for obj_dummy

// Run the parent's event first to inherit basic functionality
event_inherited();

// Override parent behavior to ensure dummy never moves
// Force velocity to zero to prevent any movement
vel_x = 0;
vel_y = (grounded) ? 0 : vel_y; // Only allow vertical movement if in the air (for gravity)

// Reset flash timer if needed
if (flash) {
    if (flash_timer <= 0) {
        flash = false;
    }
}

// Reset the hit flag after being hit
if (has_been_hit) {
    has_been_hit = false;
}

// Note: The inherited end step from the parent will still run code for wall detection,
// edge detection, and collision with other enemies, but since we're forcing
// vel_x to 0 here AFTER the parent's code runs, none of that will actually
// cause the dummy to move.