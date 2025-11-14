//step event
/// @description Step Event
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

// Get distance to player
var distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);

// State machine
switch(state) {
    case goblinState.Patrol:
        #region Patrol State
        sprite_index = sGoblinWalk;
        image_speed = 1;
        
        // Move back and forth on platform
        vel_x = patrol_dir * patrol_speed;
        
        // Increment patrol timer
        patrol_time++;
        
        // If patrol time exceeded, change direction
        if (patrol_time >= patrol_duration) {
            patrol_dir = -patrol_dir;
            patrol_time = 0;
        }
        
        // Check if player is within chase range
        if (distance_to_player <= chase_range) {
            state = goblinState.Chase;
        }
        #endregion
        break;
        
    case goblinState.Chase:
        #region Chase State
        sprite_index = sGoblinWalk;
        image_speed = 1;
        
        // Make sure enemy faces the player
        image_xscale = sign(obj_player.x - x);
        if (image_xscale == 0) image_xscale = 1;
        
        // Check if within attack range first (since it's smaller than chase range)
        if (distance_to_player <= attack_range && can_attack) {
            state = goblinState.Attack;
            vel_x = 0; // Stop movement when attacking
            sprite_index = sGoblinSlash;
            image_index = 0;
        }
        // Otherwise if within chase range, move toward player
        else if (distance_to_player <= chase_range) {
            vel_x = sign(obj_player.x - x) * chase_speed;
        }
        // If outside chase range, return to patrol
        else {
            state = goblinState.Patrol;
            patrol_time = 0;
        }
        #endregion
        break;
        
    case goblinState.Attack:
        #region Attack State
        if (sprite_index != sGoblinSlash) {
            sprite_index = sGoblinSlash;
            image_index = 0;
        }
        
        image_speed = 0.6;
        vel_x = 0; // Ensure no movement during attack
        
        // Only set cooldown and can_attack once at the start of the attack
        if (image_index < 1) {
            can_attack = false;
            attack_cooldown = attack_cooldown_max;
        }
        
        // Check if animation has ended (this is crucial)
        if (animation_end()) {
            state = goblinState.Chase;
            sprite_index = sGoblinWalk;
            image_index = 0;
        }
        #endregion
        break;
        
    case goblinState.Hurt:
        #region Hurt State
        // Make sure we're using the hurt sprite
        if (sprite_index != hurt_sprite) {
            sprite_index = hurt_sprite;
            image_index = 0;
        }
        
        image_speed = 1;
        
        // Let knockback handle movement during hurt state
        // If knockback is active, the velocity is controlled by knockback
        if (knockback_timer > 0) {
            // Velocity already set in enemy_take_damage function
        } else {
            vel_x = 0; // Stop movement when not in knockback
        }
        
        // Return to chase state when hurt timer expires
        if (hurt_timer <= 0) {
            state = goblinState.Chase;
            sprite_index = sGoblinWalk;
            image_index = 0;
        }
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