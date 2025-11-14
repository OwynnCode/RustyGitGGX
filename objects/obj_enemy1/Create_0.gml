//create event for obj_enemy1 (goblin)
event_inherited();

// Make sure sprite_index is initialized
sprite_index = sGoblinWalk; // Set default sprite

// State variables - add enum for better state management
enum goblinState {
    Idle,
    Patrol,
    Chase,
    Attack,
    Hurt
}

// Set initial state
state = goblinState.Patrol;

// Configuration variables
chase_range = 150;
attack_range = 64;
chase_speed = 3;
patrol_speed = 2;

// Patrol variables
patrol_dir = choose(-1, 1);
patrol_time = 0;
patrol_duration = room_speed * 4; // Walk for 4 seconds before turning

// Attack variables
attack_cooldown = 0;
attack_cooldown_max = room_speed * 1.5; // 1 second between attacks
can_attack = true;
damage = 1; // Add this line to fix the error

// Hurt state variables
hurt_timer = 0;
hurt_duration = 30; // How long goblin stays in hurt state
flash = false; // For hit effect
hp = 3; // Health points

// Use the correct sprite names
hurt_sprite = sGoblinHurt; // Now using correct sprite
defeated_object = obj_enemy1_defeated;

// Add these new variables for knockback and hit reactions
has_been_hit = false;           // Flag for tracking if enemy was just hit
knockback_speed = 5;            // Initial knockback speed
knockback_duration = 15;        // Frames for knockback effect
knockback_timer = 0;            // Current knockback timer
flash_duration = 10;            // How long to flash
flash_timer = 0;                // Current flash timer
previous_state = goblinState.Patrol; // Store previous state 
