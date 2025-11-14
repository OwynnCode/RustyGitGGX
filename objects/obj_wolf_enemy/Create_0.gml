//create event for obj_wolf_enemy
event_inherited();

// Make sure sprite_index is initialized
sprite_index = sWolfWalk; // Set default sprite

// State variables - already defined in parent
// enum goblinState { Idle, Patrol, Chase, Attack, Hurt }

// Set initial state
state = goblinState.Patrol;

// Configuration variables
chase_range = 200;
attack_range = 64; // Same as goblin to ensure consistent behavior
chase_speed = 4; // Faster than goblin
patrol_speed = 2.5;

// Patrol variables
patrol_dir = choose(-1, 1);
patrol_time = 0;
patrol_duration = room_speed * 4; // Walk for 4 seconds before turning

// Attack variables
attack_cooldown = 0;
attack_cooldown_max = room_speed * 1.5; // 1.5 seconds between attacks
can_attack = true;
damage = 2; // Higher damage than goblin

// Hurt state variables
hurt_timer = 0;
hurt_duration = 30; // How long wolf stays in hurt state
flash = false; // For hit effect
hp = 4; // More health than goblin

// Use the correct sprite names
hurt_sprite = sWolfHurt;
defeated_object = obj_wolf_defeated;

// Add these new variables for knockback and hit reactions
has_been_hit = false; // Flag for tracking if enemy was just hit
knockback_speed = 5; // Initial knockback speed
knockback_duration = 15; // Frames for knockback effect
knockback_timer = 0; // Current knockback timer
flash_duration = 10; // How long to flash
flash_timer = 0; // Current flash timer
previous_state = goblinState.Patrol; // Store previous state

// Attack sprites and hitboxes
attackSpr = sWolfPunch; // Wolf attack sprite
attackHBSpr = sWolfPunchHB; // Wolf hitbox sprite