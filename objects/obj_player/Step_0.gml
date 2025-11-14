//Step event

// Positional audio
audio_listener_set_position(0, x, y, 0);

// Process attack cooldown
if (attackCooldown > 0) {
	attackCooldown--;
	if (attackCooldown <= 0) {
		canAttack = true;
	}
}

// Update attack key press
attackKeyPressed = keyboard_check_pressed(ord("Q"));

// Check for thrust attack (W key)
var thrustKeyPressed = keyboard_check_pressed(ord("W"));

// Check for plunge attack (E key)
var plungeKeyPressed = keyboard_check_pressed(ord("E")) && plunge_landing_timer <= 0;

// Check for run key input
var run_key_pressed = keyboard_check(ord("1"));

// Execute related fucntion to player state
switch (state) {
	case playerState.Free:
	if (!in_knockback) {
// Check left and right keys for horizontal movement
		var _move_left = keyboard_check(vk_left);
		var _move_right = keyboard_check(vk_right);
// Calculate horizontal movement direction (-1 for left, 1 for right, 0 for none)
		var _move_direction = _move_right - _move_left;
// Handle running
		if (run_key_pressed && _move_direction != 0 && grounded) {
			is_running = true;
			move_speed = normal_move_speed * run_speed_multiplier;
			if (sprite_index != run_sprite && abs(vel_x) > 0) {
				sprite_index = run_sprite;
				image_index = 0;
			}
		} else {
			is_running = false;
			move_speed = normal_move_speed;
	}
// Set horizontal velocity based on direction and move speed
		vel_x = _move_direction * move_speed;
// Check for jump input
		var _jump_pressed = keyboard_check_pressed(vk_space) ||
		keyboard_check_pressed(vk_up);
// If jump is pressed and player is on ground, apply jump velocity
		if (_jump_pressed && grounded) {
			vel_y = -jump_speed;
			sprite_index = sJump;
			image_index = 0;
			audio_play_sound(snd_jump, 0, 0);
	}
}
// Process attack input
if (attackKeyPressed && canAttack) {
	state = playerState.Attack_Slash;
	image_index = 0; // Reset animation
	ds_list_clear(hitEnemies); // Clear hit list for new attack
	canAttack = false;
	attackCooldown = attackCooldownMax;
	break; // Exit the switch to skip movement code
}
// Process thrust attack input
if (thrustKeyPressed && canAttack && grounded) {
	state = playerState.Attack_Thrust;
	sprite_index = thrust_sprite; // Set sprite
	image_index = 0; // Reset animation
	image_xscale = 1.8 * sign(image_xscale); // Preserve direction with 1.8x scale
	image_yscale = 1.8; // Upscale to 1.8x normal size
	ds_list_clear(hitEnemies); // Clear hit list for new attack
	canAttack = false;
	attackCooldown = attackCooldownMax;
	break; // Exit the switch to skip movement code
}
// Process plunge attack input
if (plungeKeyPressed && canAttack && !grounded && plunge_landing_timer <= 0) {
	state = playerState.Attack_Plunge;
	sprite_index = plunge_sprite; // Set sprite immediately
	image_index = 0; // Reset animation
	image_xscale = 0.99 * sign(image_xscale);
	image_yscale = 0.995;
	ds_list_clear(hitEnemies); 
	canAttack = false;
	attackCooldown = attackCooldownMax;
	is_plunging = true;
	has_plunge_hit = false;
	vel_x = 0; // Stop horizontal movement
	vel_y = plunge_speed; // Set downward velocity
	break; // Exit the switch to skip movement code
}
// This section below handles pixel-perfect collision checking
// X-axis collision checking
var _move_count = abs(vel_x);
var _move_once = sign(vel_x);
repeat (_move_count) {
	var _collision_found;
	try {
		_collision_found = check_collision(_move_once, 0);
} catch (e) {
// Fallback to simple collision if the function fails
	_collision_found = place_meeting(x + _move_once, y, obj_collision);
}
	if (!_collision_found) {
		x += _move_once;
} else {
	vel_x = 0;
	break;
	}
}
// Y-axis collision checking
var _move_count = abs(vel_y);
var _move_once = sign(vel_y);
repeat (_move_count) {
	var _collision_found;
try {
	_collision_found = check_collision(0, _move_once);
} catch (e) {
// Fallback to simple collision if the function fails
	_collision_found = place_meeting(x, y + _move_once, obj_collision);
}
	if (!_collision_found) {
		y += _move_once;
} else {
		vel_y = 0;
		break;
	}
}
break;

case playerState.Attack_Slash:
PlayerState_Attack_Slash();
// Handle gravity and Y collision during attack
vel_y += grav_speed;
// Y collision handling
var _move_count = abs(vel_y);
var _move_once = sign(vel_y);
repeat (_move_count) {
	var _collision_found;
	try {
		_collision_found = check_collision(0, _move_once);
	} catch (e) {
// Fallback to simple collision if the function fails
		_collision_found = place_meeting(x, y + _move_once, obj_collision);
	}
		if (!_collision_found) {
			y += _move_once;
	} else {
			vel_y = 0;
			break;
		}
}
break;

case playerState.Attack_Combo:
PlayerState_Attack_Combo();
// Y collision handling inside combo function
break;

case playerState.Attack_Thrust:
PlayerState_Attack_Thrust();
// handle gravity and Y collision during attack
vel_y += grav_speed;
// Y collision handling
var _move_count = abs(vel_y);
var _move_once = sign(vel_y);
repeat (_move_count) {
	var _collision_found;
	try {
		_collision_found = check_collision(0, _move_once);
	} catch (e) {
// Fallback to simple collision if the function fails
		_collision_found = place_meeting(x, y + _move_once, obj_collision);
	}
	if (!_collision_found) {
		y += _move_once;
	} else {
		vel_y = 0;
	break;
	}
}
break;

case playerState.Attack_Plunge:
PlayerState_Attack_Plunge();
// Y collision handling for plunge
var _move_count = abs(vel_y);
var _move_once = sign(vel_y);
repeat (_move_count) {
	var _collision_found;
try {
	_collision_found = check_collision(0, _move_once);
	} catch (e) {
// Fallback to simple collision if the function fails
	_collision_found = place_meeting(x, y + _move_once, obj_collision);
	}
	if (!_collision_found) {
		y += _move_once;
	} else {
// Hit ground during plunge(landing sequence)
	if (is_plunging && !has_plunge_hit) {
// Reset scaling before changing state
		image_xscale = sign(image_xscale);
		image_yscale = 1;
// Restore original mask for proper collision
		mask_index = original_mask;
// Bounce physics
		vel_x = plunge_bounce_x;
		vel_y = plunge_bounce_speed;
		state = playerState.Free;
		sprite_index = sJump;
		is_plunging = false;
		has_plunge_hit = false;
// Start landing buffer
		plunge_landing_timer = plunge_landing_buffer;
// Proper ground positioning
		var adjustment_tries = 0;
			while (adjustment_tries < 5 && place_meeting(x, y, obj_collision)) {
				y -= 1;
				adjustment_tries++;
			}
		} else {
				vel_y = 0;
	}
			break;
		}
	}
	break;
}

// Prevent floor clipping
if (state == playerState.Free && grounded && !is_plunging) {
// Check if we're correctly positioned on the ground
	var ground_below;
	try {
		ground_below = check_collision(0, 1);
	} catch (e) {
		ground_below = place_meeting(x, y + 1, obj_collision);
	}
	if (!ground_below) {
// If player should be touching the ground but isn't -> move down
		var max_down = 5; // Limit how far we check to avoid falling through large gaps
		for (var i = 1; i <= max_down; i++) {
			var found_ground;
			try {
				found_ground = check_collision(0, 1);
			} catch (e) {
				found_ground = place_meeting(x, y + 1, obj_collision);
			}
			if (found_ground) {
// Found ground
				break;
				}
			y += 1;
			}
		}
}

// Process arrow cooldown
if (shoot_cooldown > 0) {
	shoot_cooldown--;
	if (shoot_cooldown <= 0) {
		can_shoot = true;
	}
}

// Input check for bow 
var _bow_key_pressed = keyboard_check_pressed(ord("A"));

// Only allow bow if not in knockback
if (_bow_key_pressed && can_shoot && !in_knockback) {
	state = playerState.Bow;
	sprite_index = bow_sprite;
	image_index = 0;
	vel_x = 0; // Stop horizontal movement
}

// Update switch cases to include the Bow case
switch (state) {
	case playerState.Bow:
	PlayerState_Bow();
	break;
}

// Track sprite changes
sPrevious = sprite_index;