//step event for obj_gArrow
// Only process movement if the arrow hasn't hit anything yet
if (!has_hit) {
    // Apply gravity to the vertical speed, but only after a short delay
    // This creates a flatter initial trajectory before gravity takes effect
    flight_time += 1;
    
    // Only start applying gravity after extended initial flat flight
    if (flight_time > 12) {
        speed_y += arrow_gravity;
    }
    
    // Keep arrows completely horizontal throughout flight
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
    
    // Check for collision with player (skip if player is invincible)
    if (instance_exists(obj_player) && place_meeting(x, y, obj_player)) {
        with (obj_player) {
            if (no_hurt_frames <= 0) {
                // Damage player
                hp -= other.damage;
                in_knockback = true;
                no_hurt_frames = 120;
                sprite_index = sHurt;
                image_index = 0;
                vel_x = sign(x - other.x) * 15;
                alarm[0] = 15;
                
                // Play life lost sound when player is hit by arrow
                if (audio_exists(snd_life_lost_01)) {
                    audio_play_sound(snd_life_lost_01, 10, false);
                }
            }
        }
        
        // Stick to player if this is the first hit
        if (!has_hit) {
            has_hit = true;
            alarm[0] = lifespan;
        }
    }
}