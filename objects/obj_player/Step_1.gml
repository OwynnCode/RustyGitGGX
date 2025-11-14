// begin step event
// Check if there is a collision 1 pixel below the character(player is standing)
var collision_below = false;
try {
collision_below = check_collision(0, 1);
} catch (e){
// Fallback to simple object collision if check_collision fails
collision_below = place_meeting(x, y + 1, obj_collision);
}
grounded = collision_below;

if (grounded){
	grounded_x = x;
	grounded_y = y;
// Reset double jump when landing
	has_double_jumped = false;
// Check if plunge attack hit ground with proper scale handling
	if (is_plunging && state == playerState.Attack_Plunge) {
// Reset scale BEFORE applying bounce physics
		image_xscale = sign(image_xscale);
		image_yscale = 1;
// Restore original mask to ensure proper collision
		mask_index = original_mask;
// Bounce back to the left
		vel_x = plunge_bounce_x;
		vel_y = plunge_bounce_speed;
		state = playerState.Free;
		sprite_index = sJump;
		is_plunging = false;
		has_plunge_hit = false;
// Start landing buffer to prevent immediate re-plunge
		plunge_landing_timer = plunge_landing_buffer;
// Proper ground alignment
		var ground_check = 0;
			while (ground_check < 10 && place_meeting(x, y, obj_collision)) {
				y -= 1;
				ground_check++;
			}
// Ensure player is touching the ground
			while (ground_check < 10 && !place_meeting(x, y + 1, obj_collision)) {
				y += 1;
				ground_check++;
			}
	}
}

// Decrement plunge landing timer
if (plunge_landing_timer > 0) {
plunge_landing_timer--;
}

// Apply friction to the player's velocity, so it eventually comes to a stop when there is no input.
if (round(vel_x) != 0) {
// Calculate if the friction should be applied this frame
	var _friction_applied = sign(vel_x) * friction_power;
// Check if player isn't grounded(mid-air). If player's mid-air reduce the friction that's applied to their velocity
	if (!grounded){
		_friction_applied = _friction_applied / 4;
	}
	vel_x -= _friction_applied;
}
// Handle if player has no X velocity, or it's less than 0.5 pixels in either direction
else {
	vel_x = 0;
}

// Add gravity speed value to the player's vertical velocity
vel_y += grav_speed;

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