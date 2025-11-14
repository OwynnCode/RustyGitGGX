//STEP EVENT
event_inherited();

// Check if player exists
if (!instance_exists(obj_player)) {
    vel_x = 0;
    exit;
}

// Animation end check function
function animation_end() {
    return (image_index + image_speed >= image_number);
}

// distance to player
var distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);
var player_direction = sign(obj_player.x - x); // Direction toward player

// Update player in striking range flag
player_in_striking_range = (distance_to_player <= attack_range);

// State machine
switch(state) {
    case knightState.Patrol:
        #region Patrol State
        sprite_index = sKnightWalk;
        image_speed = 0.8;
        
        // Patrol movement
        vel_x = patrol_dir * patrol_speed;
        
        // Face movement direction
        image_xscale = patrol_dir;
        
        // Increment patrol timer
        patrol_time++;
        
        // If patrol time exceeded, change direction
        if (patrol_time >= patrol_duration) {
            patrol_dir = -patrol_dir;
            patrol_time = 0;
        }
        
        // Check if player is within chase range
        if (distance_to_player <= chase_range) {
            state = knightState.Chase;
            has_attacked_this_encounter = false;
        }
        #endregion
        break;
        
    case knightState.Chase:
        #region Chase State
        sprite_index = sKnightWalk;
        image_speed = 1;
        
        // Make sure enemy faces the player
        image_xscale = player_direction;
        if (image_xscale == 0) image_xscale = 1;
        
        // Check if within block range and should start blocking
        if (distance_to_player <= block_range && distance_to_player > attack_range && !has_attacked_this_encounter) {
            state = knightState.Block;
            vel_x = 0;
            waiting_for_player_attack = true;
            wait_timer = max_wait_time;
            // Ensure proper facing for block
            image_xscale = player_direction;
        }
        // Check if within attack range and can attack
        else if (distance_to_player <= attack_range && can_attack) {
            state = knightState.Attack;
            vel_x = 0;
            sprite_index = sKnightSlash;
            image_index = 0;
            has_attacked_this_encounter = true;
            // Face player for attack
            image_xscale = player_direction;
        }
        // Otherwise if within chase range, move toward player
        else if (distance_to_player <= chase_range) {
            vel_x = player_direction * chase_speed;
        }
        // If outside chase range, return to patrol
        else {
            state = knightState.Patrol;
            patrol_time = 0;
            has_attacked_this_encounter = false;
        }
        #endregion
        break;
        
    case knightState.Block:
        #region Block State
        sprite_index = sKnightBlock;
        image_speed = 1;
        vel_x = 0; // Stay still while blocking
        
        // Always face the player while blocking
        image_xscale = player_direction;
        if (image_xscale == 0) image_xscale = 1;
        
        is_blocking = true;
        
        // If player moves out of block range or wait time expires, attack
        if (distance_to_player > block_range || wait_timer <= 0) {
            if (distance_to_player <= attack_range && can_attack) {
                state = knightState.Attack;
                sprite_index = sKnightSlash;
                image_index = 0;
                is_blocking = false;
                has_attacked_this_encounter = true;
                // Maintain facing direction for attack
                image_xscale = player_direction;
            } else {
                state = knightState.Chase;
                is_blocking = false;
            }
        }
        
        // If player gets too close while blocking, counterattack
        if (distance_to_player <= attack_range && can_attack && waiting_for_player_attack) {
            state = knightState.Attack;
            sprite_index = sKnightSlash;
            image_index = 0;
            is_blocking = false;
            waiting_for_player_attack = false;
            has_attacked_this_encounter = true;
            // Face player for counterattack
            image_xscale = player_direction;
        }
        #endregion
        break;
        
    case knightState.Attack:
        #region Attack State
        if (sprite_index != sKnightSlash) {
            sprite_index = sKnightSlash;
            image_index = 0;
        }
        
        image_speed = 0.6;
        vel_x = 0; // Ensure no movement during attack
        
        // Maintain facing direction during attack
        // Don't change facing once attack has started
        // Set cooldown and can_attack once at the start of the attack
        if (image_index < 1 && can_attack) {
            can_attack = false;
            attack_cooldown = attack_cooldown_max;
        }
        
        // Check if animation has ended
        if (animation_end()) {
            state = knightState.Chase;
            sprite_index = sKnightWalk;
            image_index = 0;
        }
        #endregion
        break;
        
    case knightState.Stunned:
        #region Stunned State
        // Make sure we're using the stunned sprite
        if (sprite_index != sKnightStunned) {
            sprite_index = sKnightStunned;
            image_index = 0;
        }
        
        image_speed = 1;
        vel_x = 0; // No movement while stunned
        
        // Maintain facing direction from when stunned was triggered
        
        // Flash effect while stunned 
        #endregion
        break;
        
    case knightState.Hurt:
        #region Hurt State
        // Make sure we're using the hurt sprite
        if (sprite_index != hurt_sprite) {
            sprite_index = hurt_sprite;
            image_index = 0;
        }
        
        image_speed = 1;
        
        // Maintain facing direction from when hurt was triggered
        // Don't change facing during hurt state
        
        // Let knockback handle movement during hurt state
        if (knockback_timer <= 0) {
            vel_x = 0; // Stop movement when not in knockback
        }
        
        // Return to chase state when hurt timer expires (handled in begin step)
        #endregion
        break;
}

// Process attack cooldown
if (!can_attack) {
    attack_cooldown--;
    if (attack_cooldown <= 0) {
        can_attack = true;
    }
}

// Check if HP is less than or equal to 0
if (hp <= 0) {
    // Create defeated object
    instance_create_layer(x, y, layer, defeated_object);
    // Destroy this instance
    instance_destroy();
}