//step event for obj_ranged_goblin
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
var dir_to_player = sign(obj_player.x - x);

// Line of sight check function
function has_line_of_sight() {
    if (!instance_exists(obj_player)) return false;
    
    var check_x = x;
    var check_y = y - 8; // Adjust to be at eye level
    var player_y = obj_player.y - 8;
    var dir = sign(obj_player.x - x);
    var max_dist = point_distance(x, check_y, obj_player.x, player_y);
    var step_size = 4;
    
    for (var dist = 0; dist < max_dist; dist += step_size) {
        var pos_x = check_x + dir * dist;
        var pos_y = check_y + (player_y - check_y) * (dist / max_dist);
        
        // Use try-catch in case position_meeting fails
        try {
            if (position_meeting(pos_x, pos_y, obj_collision)) {
                return false;
            }
        } catch (e) {
            // Fallback to simpler collision check
            if (place_meeting(pos_x, pos_y, obj_collision)) {
                return false;
            }
        }
    }
    
    return true;
}

// State machine
switch(state) {
    case goblinState.Patrol:
        #region Patrol State
        sprite_index = sRGoblinWalk;
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
        sprite_index = sRGoblinWalk;
        image_speed = 1;
        
        // Make sure enemy faces the player
        image_xscale = dir_to_player;
        if (image_xscale == 0) image_xscale = 1;
        
        // Check if within attack range, not too close, and has line of sight
        if (distance_to_player <= attack_range && 
            distance_to_player >= min_attack_range && 
            can_attack && 
            has_line_of_sight()) {
            state = goblinState.Attack;
            vel_x = 0; // Stop movement when attacking
            sprite_index = sGoblinArrow;
            image_index = 0;
            has_fired_arrow = false; // Reset arrow fired flag
            
            // Ensure the goblin is facing the player when entering attack state
            image_xscale = dir_to_player;
            if (image_xscale == 0) image_xscale = 1;
        }
        // If too close to player, move away
        else if (distance_to_player < retreat_range) {
            vel_x = -dir_to_player * chase_speed;
        }
        // If within chase range but not attack range, move toward player but maintain ideal distance
        else if (distance_to_player <= chase_range) {
            if (distance_to_player < ideal_distance - 10) {
                // Too close, back away slightly
                vel_x = -dir_to_player * chase_speed * 0.7;
            } 
            else if (distance_to_player > ideal_distance + 10) {
                // Too far, approach player
                vel_x = dir_to_player * chase_speed;
            }
            else {
                // At ideal distance, stop moving
                vel_x = 0;
            }
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
        if (sprite_index != sGoblinArrow) {
            sprite_index = sGoblinArrow;
            image_index = 0;
        }
        
        image_speed = 0.6;
        vel_x = 0; // Ensure no movement during attack
        
        // Always update facing direction during attack animation
        // to track player movement even while preparing to shoot
        var new_dir_to_player = sign(obj_player.x - x);
        if (new_dir_to_player != 0) {
            image_xscale = new_dir_to_player;
        }
        
        // Only set cooldown and can_attack once at the start of the attack
        if (image_index < 1) {
            can_attack = false;
            attack_cooldown = attack_cooldown_max;
        }
        
        // Create arrow at the 4th frame of animation
        // Since animation indices start at 0, we check for image_index >= 3 and < 4
        if (image_index >= 3 && image_index < 4 && !has_fired_arrow) {
            has_fired_arrow = true; // Flag to ensure only one arrow per attack
            
            // Raise the arrow release point significantly to avoid floor collision
            var arrow_x = x + 12 * image_xscale;
            var arrow_y = y - 20; // Raised from -10 to -20
            
            // Create the enemy arrow instance
            var arrow = instance_create_layer(arrow_x, arrow_y, "Instances", obj_gArrow);
            
            // Set arrow properties
            arrow.facing = image_xscale;
            
            // Set the proper goblin arrow sprites based on direction
            if (image_xscale == 1) { // Right
                arrow.sprite_index = gArrowRight;
            } else { // Left
                arrow.sprite_index = gArrowLeft;
            }
            
            // CORRECTION: Explicitly set arrow scale to 15% of original (smaller than before)
            arrow.image_xscale = 0.15;
            arrow.image_yscale = 0.15;
            
            // Set arrow speed and damage
            arrow.speed_x = arrow_speed;
            arrow.damage = arrow_damage;
            arrow.speed_y = -0.7; // Increased upward velocity to avoid floor
            
            // Play shoot sound (if exists)
            if (variable_global_exists("snd_bow_fire") && audio_exists(snd_bow_fire)) {
                audio_play_sound(snd_bow_fire, 0, 0);
            }
        }
        
        // Better animation end detection
        if (animation_end() || image_index >= 6.5) { // Check for both animation_end() and near-end frame
            has_fired_arrow = false; // Reset the flag
            
            // CORRECTION: Reset velocity variables and state
            vel_x = 0;
            state = goblinState.Chase;
            sprite_index = sRGoblinWalk;
            image_index = 0; // Reset animation index
            image_speed = 1; // Reset animation speed
            
            // Force an immediate re-evaluation of chase behavior on the next frame
            // This prevents the "stuck in place" issue
            alarm[0] = 1;
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
        if (knockback_timer > 0) {
            // Velocity already set in enemy_take_damage function
        } else {
            vel_x = 0; // Stop movement when not in knockback
        }
        
        // Return to chase state when hurt timer expires
        if (hurt_timer <= 0) {
            state = goblinState.Chase;
            sprite_index = sRGoblinWalk;
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