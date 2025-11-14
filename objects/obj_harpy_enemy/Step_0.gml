//step event for obj_harpy
/// @description Step Event
event_inherited();

// Check if player exists
if (!instance_exists(obj_player)) {
    vel_x = 0;
    vel_y = 0;
    exit;
}

// Animation end check function
function animation_end() {
    return (image_index + image_speed >= image_number);
}

// Get distance to player - use better detection for vertical distance
var horizontal_distance = abs(obj_player.x - x);
var vertical_distance = abs(obj_player.y - y);
var distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);

// Keep harpy within screen bounds (add padding)
var screen_margin = 50;
if (x < screen_margin) {
    patrol_dir = 1;
    patrol_target_x = start_x + patrol_distance;
}
else if (x > room_width - screen_margin) {
    patrol_dir = -1;
    patrol_target_x = start_x - patrol_distance;
}

// State machine
switch(state) {
    case harpyState.Patrol:
        #region Patrol State
        sprite_index = sHarpyFly;
        image_speed = 1;
        collision_damage_enabled = true; // Enable collision damage in patrol
        
        // Natural bobbing flight pattern
        var bob_offset = sin(float_timer) * float_amplitude;
        var target_y = base_y + bob_offset;
        
        // Move towards patrol target
        vel_x = sign(patrol_target_x - x) * patrol_speed;
        
        // Smooth Y movement to bobbing position
        if (abs(y - target_y) > 2) {
            vel_y = sign(target_y - y) * 2;
        } else {
            vel_y = 0;
        }
        
        // Face movement direction
        if (vel_x != 0) {
            image_xscale = sign(vel_x);
        }
        
        // Check if reached patrol target
        if (abs(x - patrol_target_x) < 20) {
            patrol_dir = -patrol_dir;
            patrol_target_x = start_x + (patrol_dir * patrol_distance);
        }
        
        // Better detection - check if player is within detection range OR directly below/above
        var in_range = (distance_to_player <= detection_range);
        var directly_below = (horizontal_distance <= 120 && vertical_distance <= detection_range);
        
        if ((in_range || directly_below) && can_attack) {
            state = harpyState.Swoop;
            swoop_start_y = y;
            swoop_target_x = obj_player.x;
            swoop_target_y = obj_player.y;
            is_swooping = true;
            collision_damage_enabled = false; // Disable collision damage during swoop
        }
        #endregion
        break;
        
    case harpyState.Swoop:
        #region Swoop State
        sprite_index = sHarpyFly;
        image_speed = 1.4; // Faster animation when swooping
        collision_damage_enabled = false; // No collision damage during swoop
        
        // Update target position to track moving player
        swoop_target_x = obj_player.x;
        swoop_target_y = obj_player.y;
        
        // Calculate direction to target
        var dir_to_target = point_direction(x, y, swoop_target_x, swoop_target_y);
        
        // Move towards target at swoop speed
        vel_x = lengthdir_x(swoop_speed, dir_to_target);
        vel_y = lengthdir_y(swoop_speed, dir_to_target);
        
        // Face movement direction
        if (abs(vel_x) > 0.1) {
            image_xscale = sign(vel_x);
        }
        
        // Check if close enough to attack
        if (distance_to_player <= attack_range) {
            state = harpyState.Attack;
            vel_x = 0;
            vel_y = 0;
            sprite_index = sHarpySmash;
            image_index = 0;
            image_speed = 1.0; // Smoother attack animation
            can_attack = false;
            attack_cooldown = attack_cooldown_max;
            attack_hitbox_created = false; // Reset hitbox flag
            attack_damage_dealt = false; // Reset damage flag
            collision_damage_enabled = false; // No collision damage during attack
        }
        
        // If player moved too far, return to patrol
        else if (distance_to_player > detection_range * 1.2) {
            state = harpyState.Return;
            is_swooping = false;
            is_returning = true;
            collision_damage_enabled = false; // No collision damage during return
        }
        #endregion
        break;
        
    case harpyState.Attack:
        #region Attack State
        // Ensure sprite stays as attack sprite and smooth animation
        sprite_index = sHarpySmash;
        image_speed = 1.0;
        vel_x = 0;
        vel_y = 0;
        collision_damage_enabled = false; // Disable collision damage, only attack damage
        
        // Create precise attack hitbox during specific frames (2-4) and only once
        if (image_index >= 2 && image_index < 5 && !attack_damage_dealt) {
            // Check for precise attack range - smaller than collision range
            var attack_distance = point_distance(x, y, obj_player.x, obj_player.y);
            if (attack_distance <= 40 && instance_exists(obj_player)) { // Ensure player still exists
                attack_damage_dealt = true; // Mark damage as dealt
                
                with(obj_player) {
                    if (no_hurt_frames <= 0) {
                        // Calculate knockback direction from attack position
                        var _x_sign = sign(x - other.x);
                        if (_x_sign == 0) _x_sign = other.image_xscale; // Use facing direction if directly on top
                        
                        // Strong attack knockback
                        vel_x = _x_sign * 18;
                        vel_y = -10; // Strong upward knockback from hammer smash
                        
                        // Apply damage
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
        }
        
        // Check if animation has ended OR player no longer exists
        if (animation_end() || !instance_exists(obj_player)) {
            state = harpyState.Return;
            is_swooping = false;
            is_returning = true;
            attack_hitbox_created = false;
            attack_damage_dealt = false; // Reset for next attack
        }
        #endregion
        break;
        
    case harpyState.Return:
        #region Return State
        sprite_index = sHarpyFly;
        image_speed = 1;
        collision_damage_enabled = false; // No collision damage during return
        
        // Return to base position
        var return_dir = point_direction(x, y, start_x, base_y);
        vel_x = lengthdir_x(return_speed, return_dir);
        vel_y = lengthdir_y(return_speed, return_dir);
        
        // Face movement direction
        if (abs(vel_x) > 0.1) {
            image_xscale = sign(vel_x);
        }
        
        // Check if back at base position
        var dist_to_base = point_distance(x, y, start_x, base_y);
        if (dist_to_base < 30) {
            state = harpyState.Patrol;
            is_returning = false;
            vel_y = 0; // Stop vertical movement
            collision_damage_enabled = true; // Re-enable collision damage
        }
        #endregion
        break;
        
    case harpyState.Hurt:
        #region Hurt State
        sprite_index = hurt_sprite;
        image_speed = 1;
        collision_damage_enabled = false; // No collision damage while hurt
        
        // Light knockback handling for flying enemy
        if (knockback_timer > 0) {
            // Velocity already set in enemy_take_damage function
        } else {
            // Gentle floating motion while hurt
            vel_x *= 0.9;
            vel_y *= 0.9;
        }
        
        // Return to patrol when hurt timer expires
        if (hurt_timer <= 0) {
            state = harpyState.Patrol;
            sprite_index = sHarpyFly;
            image_index = 0;
            collision_damage_enabled = true; // Re-enable collision damage
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
    // Immediately create defeated object and destroy this instance
    instance_create_layer(x, y, layer, obj_harpy_defeated);
    instance_destroy();
}