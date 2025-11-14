//step event for obj_wolf_enemy
/// @description Step Event
event_inherited();

// Check if player exists
if (!instance_exists(obj_player)) {
    vel_x = 0;
    exit;
}

// Animation end check function
function animation_end() {
    var frame = image_index;
    if (image_speed > 0) {
        return (frame + image_speed >= image_number);
    } else {
        return (frame - image_speed <= 0);
    }
}

// Process attack - using the same structure as obj_enemy1
function ProcessAttack(attackSprite, hitboxSprite, damage) {
    sprite_index = attackSprite;
    if (image_index >= 1 && image_index <= 3) {
        var hitboxX = x + 16 * image_xscale;
        var oldMask = mask_index;
        mask_index = hitboxSprite;
        
        // Check for collision with player
        if (place_meeting(hitboxX, y, obj_player)) {
            with (obj_player) {
                if (no_hurt_frames <= 0) {
                    // Damage player
                    hp -= damage;
                    in_knockback = true;
                    no_hurt_frames = 120;
                    sprite_index = sHurt;
                    image_index = 0;
                    vel_x = sign(x - other.x) * 15;
                    alarm[0] = 15;
                    
                    // Play hit sound
                    if (audio_exists(snd_life_lost_01)) {
                        audio_play_sound(snd_life_lost_01, 10, false);
                    }
                }
            }
        }
        
        mask_index = oldMask;
    }
}

// Get distance to player
var distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);
var dir_to_player = sign(obj_player.x - x);

// State machine
switch(state) {
    case goblinState.Patrol:
        #region Patrol State
        sprite_index = sWolfWalk;
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
        sprite_index = sWolfWalk;
        image_speed = 1;
        
        // Make sure enemy faces the player
        image_xscale = dir_to_player;
        if (image_xscale == 0) image_xscale = 1;
        
        // Check if within attack range first
        if (distance_to_player <= attack_range && can_attack) {
            state = goblinState.Attack;
            vel_x = 0; // Stop movement when attacking
            sprite_index = attackSpr;
            image_index = 0;
        }
        // Otherwise if within chase range, move toward player
        else if (distance_to_player <= chase_range) {
            vel_x = dir_to_player * chase_speed;
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
        vel_x = 0;
        vel_y = 0;
        grounded = true;
        
        // Process attack using same pattern as goblin
        ProcessAttack(attackSpr, attackHBSpr, damage);
        
        // Check if animation has ended
        if (animation_end()) {
            sprite_index = sWolfWalk;
            state = goblinState.Chase;
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
            sprite_index = sWolfWalk;
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