//BEGIN STEP EVENT
grounded = check_collision(0, 1);

if (grounded) {
    grounded_x = x;
    grounded_y = y;
}

// Apply friction
if (round(vel_x) != 0) {
    var _friction_applied = sign(vel_x) * friction_power;
    if (!grounded) {
        _friction_applied = _friction_applied / 4;
    }
    vel_x -= _friction_applied;
} else {
    vel_x = 0;
}

// Apply gravity
vel_y += grav_speed;

// Process knockback timer
if (knockback_timer > 0) {
    knockback_timer--;
}

// Process flash timer for hit visual effect
if (flash_timer > 0) {
    flash_timer--;
    flash = (flash_timer > 0);
}

// Process hurt state timer
if (hurt_timer > 0) {
    hurt_timer--;
    if (hurt_timer <= 0 && variable_instance_exists(id, "state")) {
        if (state == knightState.Hurt) {
            state = knightState.Chase;
        }
    }
}

// Process stunned timer
if (stunned_timer > 0) {
    stunned_timer--;
    if (stunned_timer <= 0) {
        state = knightState.Chase;
        block_broken = false; // Reset block broken flag
        block_hits = 0; // Reset block hits when exiting stunned state
    }
}

// Process block break timer(resets block hit counter if window expires)
if (block_break_timer > 0) {
    block_break_timer--;
    if (block_break_timer <= 0) {
        block_hits = 0;
    }
}

// Process block animation timer
if (block_animation_timer > 0) {
    block_animation_timer--;
}

// Process wait timer
if (wait_timer > 0) {
    wait_timer--;
}