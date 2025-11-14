//collision with obj_enemy_parent event
// This event runs when the player collides with an enemy.
// In this Zelda-style implementation, any contact with enemies hurts the player.

// This checks if the player is invincible, by checking if no_hurt_frames is greater than 0.
if (no_hurt_frames > 0)
{
    // In that case we exit the event so the player is not hurt by the enemy.
    exit;
}

// This action gets the sign (1, 0 or -1) from the enemy's position to the player's position.
var _x_sign = sign(x - other.x);

// That sign is multiplied by 15, and applied to vel_x as the knockback.
vel_x = _x_sign * 15;

// This first reduces the player's health by the damage amount in the 'other' instance
// (which is the enemy).
// Then it sets 'in_knockback' to true to tell the player that it's in knockback.
hp -= other.damage;
in_knockback = true;

// This sets no_hurt_frames to 120, so the player is invincible for the next 2 seconds (as one second contains 60 frames).
no_hurt_frames = 120;

// This changes the sprite to the hurt sprite.
sprite_index = sHurt;
image_index = 0;

// Set Alarm 0 to run after 15 frames; that event stops the player's horizontal velocity, ending the knockback
alarm[0] = 15;

// Play the 'life lost' sound effect
audio_play_sound(snd_life_lost_01, 0, 0);