//create event for obj_ranged_goblin
event_inherited();

// Make sure sprite_index is initialized
sprite_index = sRGoblinWalk; // Set default sprite

// State variables - add enum for better state management
// We'll use the same enum as regular goblin, so no need to redefine it
// enum goblinState { Idle, Patrol, Chase, Attack, Hurt }

// Set initial state
state = goblinState.Patrol;

// Configuration variables
chase_range = 250; // Larger detection range than melee goblin
attack_range = 200; // Attack from a distance
min_attack_range = 100; // Don't get too close to player
retreat_range = 80; // Distance at which goblin will back away
chase_speed = 2.5; // Slightly faster than regular goblin
patrol_speed = 1.5;

// Patrol variables
patrol_dir = choose(-1, 1);
patrol_time = 0;
patrol_duration = room_speed * 4; // Walk for 4 seconds before turning

// Attack variables
attack_cooldown = 0;
attack_cooldown_max = room_speed * 2; // 2 seconds between arrow shots
can_attack = true;
damage = 1; // Add this line to fix the error

// Hurt state variables
hurt_timer = 0;
hurt_duration = 30; // How long goblin stays in hurt state
flash = false; // For hit effect
hp = 2; // Health points - weaker than melee goblins

// Use the correct sprite names
hurt_sprite = sRGoblinHurt; // Now using correct sprite
defeated_object = obj_rgoblin_defeated; // Create this object with sRGoblinDefeated sprite

// Add these new variables for knockback and hit reactions
has_been_hit = false; // Flag for tracking if enemy was just hit
knockback_speed = 5; // Initial knockback speed
knockback_duration = 15; // Frames for knockback effect
knockback_timer = 0; // Current knockback timer
flash_duration = 10; // How long to flash
flash_timer = 0; // Current flash timer
previous_state = goblinState.Patrol; // Store previous state

// Custom variables for ranged goblin
ideal_distance = 150; // Optimal distance to maintain from player
arrow_speed = 8; // Lower than player arrows for balance
arrow_gravity = 0.05;
arrow_damage = 1;
has_fired_arrow = false; // Track if arrow was fired during attack animation