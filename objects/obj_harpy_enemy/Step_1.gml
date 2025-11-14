//begin step event for obj_harpy
// Store grounded position (though harpy doesn't use ground)
grounded_x = x;
grounded_y = base_y;

// Apply light air resistance instead of ground friction
if (round(vel_x) != 0)
{
    var _friction_applied = sign(vel_x) * friction_power;
    vel_x -= _friction_applied;
}
else
{
    vel_x = 0;
}

// No gravity for flying enemy, but apply light vertical resistance
if (round(vel_y) != 0 && knockback_timer <= 0 && !is_swooping && !is_returning)
{
    var _y_friction = sign(vel_y) * (friction_power * 0.5);
    vel_y -= _y_friction;
}
else if (knockback_timer <= 0 && !is_swooping && !is_returning)
{
    vel_y = 0;
}

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
        if (state == harpyState.Hurt) {
            state = harpyState.Patrol;
        }
    }
}

// Update float timer for natural bobbing motion
float_timer += float_frequency;
if (float_timer >= 2 * pi) {
    float_timer -= 2 * pi;
}

// Disable collision damage during swoop and attack states
collision_damage_enabled = (state != harpyState.Swoop && state != harpyState.Attack);