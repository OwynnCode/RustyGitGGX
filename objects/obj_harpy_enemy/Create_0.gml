//create event for obj_harpy
event_inherited();

// Make sure sprite_index is initialized
sprite_index = sHarpyFly; // Set default sprite

// State variables - add enum for better state management
enum harpyState {
    Patrol,
    Swoop,
    Attack,
    Return,
    Hurt
}

// Set initial state
state = harpyState.Patrol;

// Configuration variables
detection_range = 500; // Much larger detection range for arrow combat
attack_range = 48; // Slightly larger attack range for better swooping
swoop_speed = 6;
patrol_speed = 3;
return_speed = 4;

// Flight variables
base_y = y; // Store original Y position
float_amplitude = 15; // How much it bobs up and down
float_frequency = 0.05; // Speed of bobbing
float_timer = 0;

// Patrol variables
patrol_dir = choose(-1, 1);
patrol_distance = 150;
start_x = x;
patrol_target_x = x + (patrol_dir * patrol_distance);

// Attack variables
attack_cooldown = 0;
attack_cooldown_max = room_speed * 2; // 2 seconds between attacks
can_attack = true;
damage = 1;
attack_hitbox_created = false; // Track if hitbox was created this attack
attack_damage_dealt = false; // Prevent multiple damage in one attack

// Swoop variables
swoop_start_y = y;
swoop_target_x = x;
swoop_target_y = y;
is_swooping = false;
is_returning = false;

// Hurt state variables
hurt_timer = 0;
hurt_duration = 30;
flash = false;
hp = 4; // 4 health points

// Use the correct sprite names
hurt_sprite = sHarpyHurt;

// Add these new variables for knockback and hit reactions
has_been_hit = false;
knockback_speed = 3; // Lighter knockback for flying enemy
knockback_duration = 10;
knockback_timer = 0;
flash_duration = 8;
flash_timer = 0;
previous_state = harpyState.Patrol;

// Override gravity for flying enemy
grav_speed = 0; // No gravity for flying enemies
friction_power = 0.3; // Light air resistance

// Collision mask - disable collision damage during attack
collision_damage_enabled = true;