//create event
//get obj_character_parent create event
event_inherited();

coins = 0;
//Player not stunned(didn't get hit yet)
in_knockback = false;
//Replaces the player once it is defeated.
defeated_object = obj_player_defeated;
//Track sprite changes
sPrevious = sprite_index;
// Add to Create Event - position correction for combo transitions
global.performing_combo_transition = false;
global.pre_combo_y = 0;
global.pre_combo_bottom = 0;
combo_start_timer = 0;
//Movement variables
move_speed = 12
jump_speed = 18;
// Running variables(defunct running feature removed)
is_running = false;
run_speed_multiplier = 1.6; // Speed multiplier when running
normal_move_speed = move_speed; // Store the original move speed
run_sprite = sRun; // The sprite to use when running
// State enum
enum playerState {
Free,
Attack_Slash,
Attack_Combo,
Attack_Thrust,
Bow,
Attack_Plunge
}
//Initialize state
state = playerState.Free;
move_speed = 15;
jump_speed = 20;
//Bow variables
bow_sprite = sBow;
can_shoot = true;
shoot_cooldown_max = 45; //Frames between arrow shots
shoot_cooldown = 0;
//Thrust attack variables
thrust_sprite = sThrust;
thrust_hitbox = sThrustHB;
thrust_damage = 2;
//Plunge attack variables
plunge_sprite = sPlunge;
plunge_hitbox = sPlungeHB;
plunge_damage = 3;
plunge_speed = 12; // Player fall speed
is_plunging = false;
plunge_bounce_speed = -12; //Upward bounce after plunge impact
plunge_bounce_x = -8; //Horizontal bounce to the left
has_plunge_hit = false; //Track if plunge has hit something
//Plunge landing variables
plunge_landing_buffer = 5; //Frames to prevent immediate re-plunge
plunge_landing_timer = 0; //Landing timer

//Store original mask for collision restoration
original_mask = mask_index;