// COLLISION WITH PLAYER EVENT

if (state != knightState.Hurt && state != knightState.Stunned && hp > 0) {
    // Check if we're in attack state and in the correct frames for damage
    if (state == knightState.Attack && sprite_index == sKnightSlash) {
        // Attack frames are 5 and 6
        if (image_index >= 5 && image_index <= 6) {
            
            with(other) { // 'other' refers to the player
                // Player takes damage
                if (no_hurt_frames <= 0) {
                    // Get the sign (1, 0 or -1) from the enemy's position to the player's position
                    var _x_sign = sign(x - other.x);
                    
                    // Apply knockback to player
                    vel_x = _x_sign * 15;
                    
                    // Reduce the player's health by the damage amount
                    hp -= other.damage;
                    in_knockback = true;
                    
                    // Set no_hurt_frames so the player is invincible for the next 2 seconds
                    no_hurt_frames = 120;
                    
                    // Change the sprite to the hurt sprite
                    sprite_index = sHurt;
                    image_index = 0;
                    
                    // Set Alarm 0 to run after 15 frames to stop horizontal velocity
                    alarm[0] = 15;
                    
                    // Play the 'life lost' sound effect if available
                    if (audio_exists(snd_life_lost_01)) {
                        audio_play_sound(snd_life_lost_01, 0, 0);
                    }
                }
            }
            
            // After dealing damage, set cooldown
            can_attack = false;
            attack_cooldown = attack_cooldown_max;
        }
    }
    // Also handle collision damage if player runs into knight during other states
    else if (state != knightState.Attack && distance_to_player <= attack_range) {
        // Only deal damage if close enough and not in certain states
        if (state != knightState.Block && state != knightState.Stunned) {
            with(other) { // Player
                if (no_hurt_frames <= 0) {
                    var _x_sign = sign(x - other.x);
                    vel_x = _x_sign * 10; // Lighter knockback for collision
                    hp -= 1; // Standard collision damage
                    in_knockback = true;
                    no_hurt_frames = 90; // Shorter invincibility
                    sprite_index = sHurt;
                    image_index = 0;
                    alarm[0] = 15;
                    
                    if (audio_exists(snd_life_lost_01)) {
                        audio_play_sound(snd_life_lost_01, 0, 0);
                    }
                }
            }
        }
    }
}