// Step Event for obj_arrow
// Only process movement if the arrow hasn't hit anything yet
if (!has_hit) {
    // Apply gravity to the vertical speed, but only after a short delay
    // This creates a flatter initial trajectory before gravity takes effect
    
    // Start with a flat trajectory for the first 12 frames (increased from 10)
    if (variable_instance_exists(id, "flight_time")) {
        flight_time += 1;
    } else {
        flight_time = 0;
    }
    
    // Only start applying gravity after extended initial flat flight
    if (flight_time > 12) {
        speed_y += arrow_gravity;
    }
    
    // Keep arrows completely horizontal throughout flight
    // No angle calculation needed since we're using direction-specific sprites
    image_angle = 0; // Always keep horizontal
    
    // Check for collision with solid objects/tiles
    var _collision_found;
    try {
        _collision_found = check_collision(speed_x * facing, speed_y);
    } catch (e) {
        // Fallback to simple collision if the function fails
        _collision_found = place_meeting(x + speed_x * facing, y + speed_y, obj_collision);
    }
    
    if (_collision_found) {
        // Arrow hit something solid
        has_hit = true;
        // Play impact sound (commented out until sound is added)
        // audio_play_sound(snd_arrow_impact, 0, 0);
        // Start the despawn countdown
        alarm[0] = lifespan;
    } else {
        // Move the arrow if no collision was found
        x += speed_x * facing;
        y += speed_y;
    }
    
    // Check for collision with enemies
var _enemy_list = ds_list_create();
var _enemy_count = instance_place_list(x, y, obj_enemy_parent, _enemy_list, false);
if (_enemy_count > 0) {
    for (var i = 0; i < _enemy_count; i++) {
        var _enemy = _enemy_list[| i];
        // Only damage each enemy once
        if (ds_list_find_index(hit_enemies, _enemy) == -1) {
            with (_enemy) {
                // Special handling for dummy objects
                if (variable_instance_exists(id, "is_dummy") && is_dummy == true) { 
                    // Don't change velocity for dummy targets
                    flash = true;
                    flash_timer = flash_duration;
                    has_been_hit = true;
                    // Keep the dummy stationary
                    vel_x = 0;
                } else {
                    // Use new damage function for normal enemies
                    // The true parameter indicates this damage is from an arrow
                    enemy_take_damage(other.damage, sign(x - other.x), true);
                }
            }
            // Add enemy to the hit list
            ds_list_add(hit_enemies, _enemy);
            
            // Stick to enemy if this is the first hit
            if (!has_hit) {
                has_hit = true;
                alarm[0] = lifespan;
            }
        }
    }
    ds_list_destroy(_enemy_list);
}
    
}