// This event runs when the goblin collides with the player
// Only process damage if we're not already in hurt state and we're not dead
if (state != goblinState.Hurt && hp > 0) {
    with(other) {
        // Player takes damage
        if (no_hurt_frames <= 0) {
            // Get the sign (1, 0 or -1) from the enemy's position to the player's position.
            var _x_sign = sign(x - other.x);
            // That sign is multiplied by 15, and applied to vel_x as the knockback.
            vel_x = _x_sign * 15;
            // Reduce the player's health by the damage amount in the 'other' instance (which is the enemy).
            // Then set 'in_knockback' to true to tell the player that it's in knockback.
            hp -= other.damage;
            in_knockback = true;
            // Set no_hurt_frames to 120, so the player is invincible for the next 2 seconds
            no_hurt_frames = 120;
            // Change the sprite to the hurt sprite.
            sprite_index = sHurt;
            image_index = 0;
            // Set Alarm 0 to run after 15 frames; that event stops the player's horizontal velocity
            alarm[0] = 15;
            // Play the 'life lost' sound effect
            audio_play_sound(snd_life_lost_01, 0, 0);
        }
    }
}