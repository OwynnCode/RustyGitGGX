//===========================================
// COMPLETE ENEMY TAKE DAMAGE SCRIPT
//===========================================

// Original enemy_take_damage function for normal enemies
function enemy_take_damage(damage_amount, knockback_direction, is_from_arrow) {
    // Reduce HP
    hp -= damage_amount;
    
    // Set hit flags
    has_been_hit = true;
    flash = true;
    flash_timer = flash_duration;
    
    // Apply knockback
    vel_x = knockback_direction * knockback_speed;
    vel_y = -2; // Small upward force for better visual effect
    knockback_timer = knockback_duration;
    
    // If the hit is from an arrow, ensure the enemy is in chase state
    if (is_from_arrow && variable_instance_exists(id, "state")) {
        if (state != goblinState.Attack && state != goblinState.Hurt) {
            state = goblinState.Chase;
        }
    }
    
    // Set to hurt state if not already in it and not attacking
    if (variable_instance_exists(id, "state")) {
        if (state != goblinState.Hurt && state != goblinState.Attack) {
            // Store the previous state to return to it after hurt
            previous_state = state;
            state = goblinState.Hurt;
            hurt_timer = hurt_duration;
            sprite_index = hurt_sprite;
            image_index = 0;
        }
    }
    
    // Create hit effect
    instance_create_layer(x, y, "Instances", obj_effect_hit);
    
    // Play hit sound if you have one
    if (audio_exists(snd_enemy_hit)) {
        var _sound = audio_play_sound(snd_enemy_hit, 0, 0);
        audio_sound_pitch(_sound, random_range(0.8, 1.2));
    }
}

// Knight-specific damage function with blocking mechanics
function knight_take_damage(damage_amount, knockback_direction, is_from_player, is_thrust_attack = false) {
    
    // THRUST ATTACK - Always breaks block regardless of state
    if (is_thrust_attack && is_from_player) {
        // Thrust attack instantly breaks block and damages
        if (state == knightState.Block || is_blocking) {
            // Instantly break block with thrust
            block_broken = true;
            state = knightState.Stunned;
            stunned_timer = stunned_duration;
            sprite_index = sKnightStunned;
            image_index = 0;
            
            // Set proper facing direction for stunned state
            image_xscale = sign(knockback_direction) * -1; // Face away from attack direction
            
            // Reset block variables
            block_hits = 0;
            block_break_timer = 0;
            is_blocking = false;
            waiting_for_player_attack = false;
            
            // Strong knockback for thrust block break
            vel_x = knockback_direction * (knockback_speed * 1.2);
            vel_y = -3;
            knockback_timer = knockback_duration;
            
            // Flash effect for block break
            flash = true;
            flash_timer = flash_duration * 2; // Longer flash for block break
            
            // Play block break sound if available
            if (audio_exists(snd_block_break)) {
                audio_play_sound(snd_block_break, 0, 0);
            }
            
            // Create block break effect if available
            if (object_exists(obj_effect_block_break)) {
                instance_create_layer(x, y, "Instances", obj_effect_block_break);
            }
            
            return false; // No damage yet, but block is broken
        }
        // If already stunned, apply damage normally (fall through to stunned section)
    }
    
    // If the knight is in stunned state, take normal damage
    if (state == knightState.Stunned) {
        // Reduce HP
        hp -= damage_amount;
        
        // Set hit flags
        has_been_hit = true;
        flash = true;
        flash_timer = flash_duration;
        
        // Apply knockback with proper direction facing
        vel_x = knockback_direction * knockback_speed;
        vel_y = -3; // Small upward force
        knockback_timer = knockback_duration;
        
        // Set proper facing direction for hurt state
        image_xscale = sign(knockback_direction) * -1; // Face away from attack direction
        
        // Set to hurt state
        state = knightState.Hurt;
        hurt_timer = hurt_duration;
        sprite_index = hurt_sprite;
        image_index = 0;
        
        // Reset block variables
        block_hits = 0;
        block_break_timer = 0;
        is_blocking = false;
        block_broken = false;
        
        // Create hit effect if available
        if (object_exists(obj_effect_hit)) {
            instance_create_layer(x, y, "Instances", obj_effect_hit);
        }
        
        // Play hit sound if available
        if (audio_exists(snd_enemy_hit)) {
            var _sound = audio_play_sound(snd_enemy_hit, 0, 0);
            audio_sound_pitch(_sound, random_range(0.8, 1.2));
        }
        
        return true; // Damage was dealt
    }
    
    // If the knight is blocking and it's NOT a thrust attack, handle block mechanics
    else if (is_blocking && (state == knightState.Block) && !is_thrust_attack) {
        // Set proper facing direction for block state
        image_xscale = sign(knockback_direction) * -1; // Face toward attacker
        
        // Increment block hits
        block_hits++;
        block_break_timer = block_break_window; // Reset timer window
        
        // Show brief block animation feedback
        block_animation_timer = block_animation_duration;
        
        // Play block sound if available
        if (audio_exists(snd_block)) {
            audio_play_sound(snd_block, 0, 0);
        }
        
        // Create block effect if available
        if (object_exists(obj_effect_block)) {
            instance_create_layer(x, y, "Instances", obj_effect_block);
        }
        
        // Check if block is broken (3 normal hits)
        if (block_hits >= block_hits_to_break) {
            // Block broken! Enter stunned state
            block_broken = true;
            state = knightState.Stunned;
            stunned_timer = stunned_duration;
            sprite_index = sKnightStunned;
            image_index = 0;
            
            // Set proper facing direction for stunned state
            image_xscale = sign(knockback_direction) * -1; // Face away from attack direction
            
            // Reset block variables
            block_hits = 0;
            block_break_timer = 0;
            is_blocking = false;
            waiting_for_player_attack = false;
            
            // Apply knockback for block break
            vel_x = knockback_direction * (knockback_speed * 0.8);
            vel_y = -2;
            knockback_timer = knockback_duration * 0.7;
            
            // Flash effect for block break
            flash = true;
            flash_timer = flash_duration * 1.5;
            
            // Play block break sound if available
            if (audio_exists(snd_block_break)) {
                audio_play_sound(snd_block_break, 0, 0);
            }
            
            // Create block break effect if available
            if (object_exists(obj_effect_block_break)) {
                instance_create_layer(x, y, "Instances", obj_effect_block_break);
            }
        }
        
        return false; // No damage was dealt, but block was hit
    }
    
    // If not blocking and not stunned, automatically enter block state if possible
    else if (is_from_player && state != knightState.Attack && state != knightState.Hurt && !is_thrust_attack) {
        // Quickly enter blocking state as reaction to player attack
        state = knightState.Block;
        sprite_index = sKnightBlock;
        image_index = 0;
        is_blocking = true;
        vel_x = 0;
        
        // Face the attacker properly
        image_xscale = sign(knockback_direction) * -1; // Face toward attacker
        
        // Process this hit as a blocked attack
        block_hits = 1;
        block_break_timer = block_break_window;
        block_animation_timer = block_animation_duration;
        
        // Play block sound
        if (audio_exists(snd_block)) {
            audio_play_sound(snd_block, 0, 0);
        }
        
        // Create block effect
        if (object_exists(obj_effect_block)) {
            instance_create_layer(x, y, "Instances", obj_effect_block);
        }
        
        return false; // No damage was dealt
    }
    
    // For thrust attacks against non-blocking enemies, apply normal damage
    else if (is_thrust_attack && is_from_player) {
        hp -= damage_amount;
        has_been_hit = true;
        flash = true;
        flash_timer = flash_duration;
        vel_x = knockback_direction * knockback_speed;
        vel_y = -2;
        knockback_timer = knockback_duration;
        
        // Set proper facing direction
        image_xscale = sign(knockback_direction) * -1; // Face away from attack direction
        
        if (state != knightState.Attack) {
            state = knightState.Hurt;
            hurt_timer = hurt_duration;
            sprite_index = hurt_sprite;
            image_index = 0;
        }
        
        return true; // Damage was dealt
    }
    
    // Default case - take normal damage if somehow none of the above apply
    else {
        hp -= damage_amount;
        has_been_hit = true;
        flash = true;
        flash_timer = flash_duration;
        vel_x = knockback_direction * knockback_speed;
        vel_y = -2;
        knockback_timer = knockback_duration;
        
        // Set proper facing direction
        image_xscale = sign(knockback_direction) * -1; // Face away from attack direction
        
        if (state != knightState.Attack) {
            state = knightState.Hurt;
            hurt_timer = hurt_duration;
            sprite_index = hurt_sprite;
            image_index = 0;
        }
        
        return true; // Damage was dealt
    }
}