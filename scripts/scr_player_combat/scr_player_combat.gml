//===========================================
// COMPLETE PLAYER COMBAT SCRIPT
//===========================================

// Animation end helper function
function animation_end() {
    var frame = image_index;
    if (image_speed > 0) {
        return (frame + image_speed >= image_number);
    } else {
        return (frame - image_speed <= 0);
    }
}

// Main attack processing function
function ProcessAttack(attackSprite, hitboxSprite, damage) {
    sprite_index = attackSprite;
    if (image_index >= 1 && image_index <= 3) {
        var hitboxX = x + 16 * image_xscale;
        var oldMask = mask_index;
        mask_index = hitboxSprite;
        var enemyList = ds_list_create();
        var enemyCount = instance_place_list(hitboxX, y, obj_enemy_parent, enemyList, false);
        if (enemyCount > 0) {
            for (var i = 0; i < enemyCount; i++) {
                var enemy = enemyList[| i];
                if (ds_list_find_index(hitEnemies, enemy) == -1) {
                    with (enemy) {
                        // Check if this is a dummy
                        if (variable_instance_exists(id, "is_dummy") && is_dummy) {
                            // Dummy VFX
                            flash = true;
                            flash_timer = flash_duration;
                            // Create hit effect if exists
                            instance_create_layer(x, y, "Instances", obj_effect_hit);
                            // Enemy hit SFX
                            if (audio_exists(snd_enemy_hit)) {
                                audio_play_sound(snd_enemy_hit, 1, false);
                            }
                        } else {
                            // Check if this is a knight enemy
                            if (object_index == obj_knight || object_is_ancestor(object_index, obj_knight)) {
                                // Use knight-specific damage function (normal attack, not thrust)
                                var knockback_dir = sign(other.x - x);
                                knight_take_damage(other.attackDamage, knockback_dir, true, false); // is_thrust_attack = false
                            } else {
                                // Damage function for normal enemies
                                enemy_take_damage(other.attackDamage, sign(other.x - x), false);
                            }
                        }
                    }
                    ds_list_add(hitEnemies, enemy);
                }
            }
        }
        mask_index = oldMask;
        ds_list_destroy(enemyList);
    }
}

// Thrust attack processing function (frames 5-7)
function ProcessThrustAttack(attackSprite, hitboxSprite, damage) {
    sprite_index = attackSprite;
    if (image_index >= 5 && image_index <= 7) {
        var hitboxX = x + 16 * image_xscale;
        var oldMask = mask_index;
        mask_index = hitboxSprite;
        var enemyList = ds_list_create();
        var enemyCount = instance_place_list(hitboxX, y, obj_enemy_parent, enemyList, false);
        if (enemyCount > 0) {
            for (var i = 0; i < enemyCount; i++) {
                var enemy = enemyList[| i];
                if (ds_list_find_index(hitEnemies, enemy) == -1) {
                    with (enemy) {
                        // Check if enemy is a dummy
                        if (variable_instance_exists(id, "is_dummy") && is_dummy) {
                            // Dummy VFX
                            flash = true;
                            flash_timer = flash_duration;
                            // Create hit effect if exists
                            instance_create_layer(x, y, "Instances", obj_effect_hit);
                            // Enemy hit SFX
                            if (audio_exists(snd_enemy_hit)) {
                                audio_play_sound(snd_enemy_hit, 1, false);
                            }
                        } else {
                            // Check if this is a knight enemy
                            if (object_index == obj_knight || object_is_ancestor(object_index, obj_knight)) {
                                // Use knight-specific damage function with thrust flag
                                var knockback_dir = sign(other.x - x);
                                knight_take_damage(other.thrust_damage, knockback_dir, true, true); // is_thrust_attack = true
                            } else {
                                // Damage function for normal enemies
                                enemy_take_damage(other.thrust_damage, sign(other.x - x), false);
                            }
                        }
                    }
                    ds_list_add(hitEnemies, enemy);
                }
            }
        }
        mask_index = oldMask;
        ds_list_destroy(enemyList);
    }
}

// Plunge attack processing function (frames 5-7)
function ProcessPlungeAttack(attackSprite, hitboxSprite, damage) {
    sprite_index = attackSprite;
    if (image_index >= 5 && image_index <= 7) {
        var oldMask = mask_index;
        mask_index = hitboxSprite;
        var enemyList = ds_list_create();
        var enemyCount = instance_place_list(x, y, obj_enemy_parent, enemyList, false);
        if (enemyCount > 0) {
            for (var i = 0; i < enemyCount; i++) {
                var enemy = enemyList[| i];
                if (ds_list_find_index(hitEnemies, enemy) == -1) {
                    with (enemy) {
                        // Check if enemy is a dummy
                        if (variable_instance_exists(id, "is_dummy") && is_dummy) {
                            // Dummy VFX
                            flash = true;
                            flash_timer = flash_duration;
                            // Create hit effect if exists
                            instance_create_layer(x, y, "Instances", obj_effect_hit);
                            // Use SFX
                            if (audio_exists(snd_enemy_hit)) {
                                audio_play_sound(snd_enemy_hit, 1, false);
                            }
                        } else {
                            // Check if this is a knight enemy
                            if (object_index == obj_knight || object_is_ancestor(object_index, obj_knight)) {
                                // Use knight-specific damage function (plunge counts as normal attack)
                                var knockback_dir = sign(other.x - x);
                                knight_take_damage(other.plunge_damage, knockback_dir, true, false); // is_thrust_attack = false
                            } else {
                                // Damage function for normal enemies
                                enemy_take_damage(other.plunge_damage, sign(other.x - x), false);
                            }
                        }
                    }
                    ds_list_add(hitEnemies, enemy);
                    // Set flag that plunge hit enemy
                    if (!other.has_plunge_hit) {
                        other.has_plunge_hit = true;
                        // Reset scale setting velocity and state
                        other.image_xscale = sign(other.image_xscale);
                        other.image_yscale = 1;
                        // Bounce back to the left
                        other.vel_x = other.plunge_bounce_x;
                        other.vel_y = other.plunge_bounce_speed;
                        other.state = playerState.Free;
                        other.sprite_index = sJump;
                        other.is_plunging = false;
                        // Force grounded check
                        other.grounded = true;
                    }
                }
            }
        }
        mask_index = oldMask;
        ds_list_destroy(enemyList);
    }
}

// SLASH ATTACK STATE
function PlayerState_Attack_Slash() {
    vel_x = 0;
    vel_y = 0;
    grounded = true;
    ProcessAttack(attackSpr, attackHBSpr, attackDamage);
    if (keyboard_check_pressed(ord("Q")) && (image_index > 2)) {
        state = playerState.Attack_Combo;
        sprite_index = comboSpr;
        image_index = 0;
        ds_list_clear(hitEnemies);
        // Store pre-combo position data for position correction
        global.performing_combo_transition = true;
        global.pre_combo_y = y;
        global.pre_combo_bottom = bbox_bottom;
        // Ensure player is aligned with ground without sinking
        if (!place_meeting(x, y + 1, obj_collision)) {
            grounded = false;
        } else {
            vel_y = 0;
            grounded = true;
        }
        exit;
    }
    if (animation_end()) {
        sprite_index = sIdle;
        state = playerState.Free;
    }
}

// COMBO ATTACK STATE
function PlayerState_Attack_Combo() {
    vel_x = 0;
    // Only apply gravity if airborne
    if (!place_meeting(x, y + 1, obj_collision)) {
        vel_y += grav_speed;
        grounded = false;
    } else {
        vel_y = 0;
        grounded = true;
    }
    ProcessAttack(comboSpr, comboHBSpr, comboDamage);
    // Combo timer for follow-up attacks
    if (combo_start_timer == 0) {
        combo_start_timer = 15; // frames to allow additional combo inputs
    }
    if (combo_start_timer > 0) {
        combo_start_timer--;
    }
    if (animation_end()) {
        sprite_index = sIdle;
        state = playerState.Free;
        combo_start_timer = 0;
    }
}

// THRUST ATTACK STATE
function PlayerState_Attack_Thrust() {
    vel_x = 0;
    vel_y = 0;
    grounded = true;
    // set sprite upscale 
    sprite_index = thrust_sprite;
    image_xscale = 1.8 * sign(image_xscale);
    image_yscale = 1.8;
    image_speed = 1;
    // Use thrust attack processing function
    ProcessThrustAttack(thrust_sprite, thrust_hitbox, thrust_damage);
    if (animation_end()) {
        sprite_index = sIdle;
        state = playerState.Free;
        // Ensure scale is reset when returning to idle
        image_xscale = sign(image_xscale);
        image_yscale = 1;
    }
}

// PLUNGE ATTACK STATE
function PlayerState_Attack_Plunge() {
    // No horizontal movement during plunge
    vel_x = 0;
    vel_y = plunge_speed;
    // Set sprite and animation
    sprite_index = plunge_sprite;
    image_xscale = 0.99 * sign(image_xscale);
    image_yscale = 0.995;
    image_speed = 1;
    // Process plunge attack hitbox
    ProcessPlungeAttack(plunge_sprite, plunge_hitbox, plunge_damage);
    // Check if animation ended
    if (animation_end() && !is_plunging) {
        // Reset scale before changing state
        image_xscale = sign(image_xscale);
        image_yscale = 1;
        sprite_index = sIdle;
        state = playerState.Free;
    }
}

// BOW ATTACK STATE
function PlayerState_Bow() {
    vel_x = 0;
    // Player shouldn't be able to move while aiming/shooting(process animation)
    sprite_index = bow_sprite;
    // Scale the bow animation to be smaller
    image_xscale = 0.6 * sign(image_xscale); // Preserve facing direction
    image_yscale = 0.6;
    // Check if at release frame(frame 10)
    if (image_index >= 10 && image_index < 11) {
        // Only fire the arrow once per animation
        if (can_shoot) {
            // Create arrow release point
            var _arrow_x = x + (24 * sign(image_xscale)); // Offset from player center
            var _arrow_y = y - 30; // Higher above player center to avoid floor clipping
            // Create the arrow instance
            var _arrow = instance_create_layer(_arrow_x, _arrow_y, "Instances", obj_arrow);
            // Set arrow properties
            _arrow.facing = sign(image_xscale);
            // Directional arrow sprites
            if (sign(image_xscale) == 1) { // Facing right
                _arrow.sprite_index = sArrowRight;
                _arrow.image_xscale = 0.2;
                _arrow.image_yscale = 0.2;
            } else { // Facing left
                _arrow.sprite_index = sArrowLeft;
                _arrow.image_xscale = 0.2;
                _arrow.image_yscale = 0.2;
            }
            // Increase arrow velocity for better distance
            _arrow.speed_x = 16; // Increased from 12
            // Play shoot sound (commented out until sound is added)
            // var _sound = audio_play_sound(snd_bow_fire, 0, 0);
            // audio_sound_pitch(_sound, random_range(0.9, 1.1));
            // Start cooldown
            can_shoot = false;
            shoot_cooldown = shoot_cooldown_max;
        }
    }
    // Return to free state when animation ends
    if (animation_end()) {
        sprite_index = sIdle;
        state = playerState.Free;
        // Reset scale back to normal
        image_xscale = sign(image_xscale);
        image_yscale = 1;
    }
}