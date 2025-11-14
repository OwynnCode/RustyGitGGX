//key press “space” event 
//JumpKey Pressed event
if (grounded)
{
    // Regular jump (from ground)
    vel_y = -jump_speed;
    sprite_index = sJump;
    image_index = 0;
    grounded = false;
    instance_create_layer(x, bbox_bottom, "Instances", obj_effect_jump);
    
    // Play the jump sound with a random pitch
    var _sound = audio_play_sound(snd_jump, 0, 0);
    audio_sound_pitch(_sound, random_range(0.8, 1));
    
    // Enable double jump when player jumps from ground
    can_double_jump = true;
}
else if (can_double_jump && !has_double_jumped) // Player is in mid-air and hasn't used double jump yet
{
    // Double jump
    vel_y = -jump_speed * 0.8; // Slightly weaker than regular jump
    sprite_index = sJump;
    image_index = 0;
    
    // Mark double jump as used
    has_double_jumped = true;
    can_double_jump = false;
    
    // Create the double jump effect - centered on player rather than at feet
    instance_create_layer(x, y, "Instances", double_jump_effect);
    
    // Play double jump sound with different pitch
    var _sound = audio_play_sound(snd_jump, 0, 0);
    audio_sound_pitch(_sound, random_range(1.1, 1.3));
}
