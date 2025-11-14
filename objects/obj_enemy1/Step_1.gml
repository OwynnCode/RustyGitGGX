//begin step event
// With this function call, we are checking if there is a collision 1 pixel below the character.
grounded = check_collision(0, 1);

// This checks if 'grounded' is true. This means the character is standing on ground.
if (grounded)
{
    // Store the character's current position
    grounded_x = x;
    grounded_y = y;
}

// Apply friction if needed
if (round(vel_x) != 0)
{
    var _friction_applied = sign(vel_x) * friction_power;
    if (!grounded)
    {
        _friction_applied = _friction_applied / 4;
    }
    vel_x -= _friction_applied;
}
else
{
    vel_x = 0;
}

// Apply gravity
vel_y += grav_speed;

// Process knockback timer and flash effect
if (knockback_timer > 0) {
    knockback_timer--;
    // While in knockback, enemy velocity is already set by knockback
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
        if (state == goblinState.Hurt) {
            // Return to chase state when hurt timer expires
            state = goblinState.Chase;
        }
    }
}