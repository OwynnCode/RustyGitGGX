// Collision with obj_player event
// Only process collision damage when it's enabled and not in special states
if (collision_damage_enabled && state != harpyState.Hurt && hp > 0) {
    with(other) {
        // Player takes damage from collision (not attack)
        if (no_hurt_frames <= 0) {
            // Get the sign from the enemy's position to the player's position
            var _x_sign = sign(x - other.x);
            // Apply lighter knockback for collision damage
            vel_x = _x_sign * 10;
            vel_y = -6; // Lighter upward knockback for collision
            
            // Reduce player health
            hp -= other.damage;
            in_knockback = true;
            
            // Set invincibility frames
            no_hurt_frames = 120;
            
            // Change sprite to hurt sprite
            sprite_index = sHurt;
            image_index = 0;
            
            // Set alarm for stopping horizontal velocity
            alarm[0] = 15;
            
            // Play sound effect
            audio_play_sound(snd_life_lost_01, 0, 0);
        }
    }
}