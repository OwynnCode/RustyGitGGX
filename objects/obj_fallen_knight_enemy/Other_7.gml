// KNIGHT ENEMY - ANIMATION END EVENT

// Check if attack animation finished
if (sprite_index == sKnightSlash && state == knightState.Attack) {
    // Attack animation finished, return to chase state
    state = knightState.Chase;
    sprite_index = sKnightWalk;
    image_index = 0;
    
    // Reset attack variables
    can_attack = false;
    attack_cooldown = attack_cooldown_max;
}

// Check if hurt animation finished
else if (sprite_index == sKnightHurt && state == knightState.Hurt) {
    // Hurt animation finished, return to chase state
    state = knightState.Chase;
    sprite_index = sKnightWalk;
    image_index = 0;
}

// Check if stunned animation finished (though this is time-based, not animation-based)
else if (sprite_index == sKnightStunned && state == knightState.Stunned) {
    // Keep looping the stunned animation until timer expires
    // The actual state change is handled by the timer in begin step
    image_index = 0;
}