// obj_player end step event
event_inherited();

// switch statement that allows us to transition to some other sprite, depending on the currently assigned sprite,
switch (sprite_index){
	case sWalk:
// Set the animation speed to 1, as it may have been set to 0 during the jump animation.
	image_speed = 1;
	if (vel_x == 0){
// In that case we change its sprite to the idle one.
		sprite_index = sIdle;
	}
// Check if player should be running
	else if (is_running && grounded){
// Switch to running animation
		sprite_index = run_sprite;
		image_index = 0;
	}
// Check if the player is falling
	if (vel_y > 1){
//Switch to falling animation
		sprite_index = sFall;
		image_index = 0;
	}
	break;

// Add running sprite case
	case sRun:
// Set the animation speed to 1
	image_speed = 1;
// Check if player stopped running or moving
	if (!is_running || vel_x == 0){
		if (vel_x == 0) {
// Player stopped moving
			sprite_index = sIdle;
		} else {
// Player stopped running but still moving
			sprite_index = sWalk;
		}
	}
// Check if player is falling
	if (vel_y > 1){
// Change to falling sprite
		sprite_index = sFall;
		image_index = 0;
	}
	break;

// Player is jumping switch case 
	case sJump:
// Scale down jump animation to match other sprites
	image_xscale = 0.85 * sign(image_xscale); // Preserve facing direction
	image_yscale = 0.85;
	if (vel_y >= 0){
// Reset the frame to 0
		sprite_index = sFall;
		image_index = 0;
// Reset the animation speed to 1
		image_speed = 1;
	}
	break;

// Player is falling switch case
	case sFall:
// Scale down fall animation to match other sprites
	image_xscale = 0.85 * sign(image_xscale); // Preserve facing direction
	image_yscale = 0.85;
// This checks if the player is now on the ground
	if (grounded){
// In that case we change its sprite to the idle sprite.
		sprite_index = sIdle;
		image_speed = 1;
// Reset scale back to normal
		image_xscale = sign(image_xscale);
		image_yscale = 1;
// Landing sound effect
		audio_play_sound(snd_land_01, 0, 0);
	}
	break;

// Player is hurt switch case(knockback animation)
	case sHurt:
// Checks if the player is grounded for dust VFX
	if (grounded){
		var _dust = instance_create_layer(x, bbox_bottom, layer, obj_effect_knockback);
		_dust.image_xscale = image_xscale;
	}
	break;

// Player thrust attack switch case
	case sThrust:
	image_xscale = 1.8 * sign(image_xscale); // Preserve facing direction
	image_yscale = 1.8;
	image_speed = 1;
// Return to idle when animation ends
	if (animation_end() && state != playerState.Attack_Thrust) {
		sprite_index = sIdle;
// Reset scale back to normal
		image_xscale = sign(image_xscale);
		image_yscale = 1;
	}
	break;

// Player plunge attack switch case
	case sPlunge:
//Minimal downscaling
	image_xscale = 0.99 * sign(image_xscale);
	image_yscale = 0.995;
	image_speed = 1;
// Return to idle
	if (animation_end() && state != playerState.Attack_Plunge) {
		sprite_index = sIdle;
// Reset scale back to normal
		image_xscale = sign(image_xscale);
		image_yscale = 1;
	}
	break;

	case bow_sprite:
// Maintain smaller scale for bow animation
	image_xscale = 0.6 * sign(image_xscale); // Preserve facing direction
	image_yscale = 0.6;
	image_speed = 1;
// Return to idle when done
	if (animation_end() && state != playerState.Bow) {
		sprite_index = sIdle;
// Reset scale back to normal
		image_xscale = sign(image_xscale); // Preserve facing direction
		image_yscale = 1;
	}
	break;

// Default code for if none of the other cases are valid(current sprite isn't covered by any previous case)
	default:
}

// Position correction for combo transition
if (global.performing_combo_transition && state != playerState.Attack_Plunge) {
// First, store current bbox_bottom
	var current_bottom = bbox_bottom;
// Calculate the difference in bottom position caused by sprite change
	var bottom_difference = global.pre_combo_bottom - current_bottom;
// Apply the correction to keep feet at same position
	y += bottom_difference;
// Check if player is still on the ground
	if (!check_collision(0, 1) && check_collision(0, 2)) {
// We're 1px above ground, move down
		y += 1;
	}
// Wall collision
	if (check_collision(0, 0)) {
// Move up until not in a wall
		var max_up = 16;
		for (var i = 1; i <= max_up; i++) {
		if (!check_collision(0, -1)) {
		y -= 1;
	} else {
		break;
		}
	}
}
// Force velocity to 0 to prevent further movement from gravity
	vel_y = 0;
// Clear flag
	global.performing_combo_transition = false;
}

// Track sprite changes
sPrevious = sprite_index;