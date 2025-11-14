// CREATE EVENT
event_inherited();

// Make sure sprite_index is initialized
sprite_index = sKnightWalk;

// State variables
enum knightState {
    Idle,
    Patrol,
    Chase,
    Block,
    Attack,
    Stunned,
    Hurt
}

// Set initial state
state = knightState.Patrol;

// Configuration variables
chase_range = 180;
attack_range = 80;
block_range = 120; // Range at which knight starts blocking when player approaches
chase_speed = 2;
patrol_speed = 1.5;

// Patrol variables
patrol_dir = choose(-1, 1);
patrol_time = 0;
patrol_duration = room_speed * 3; // Walk for 3 seconds before turning

// Attack variables
attack_cooldown = 0;
attack_cooldown_max = room_speed * 2; // 2 seconds between attacks
can_attack = true;
damage = 1;

// Block variables
block_hits = 0; // Number of hits taken while blocking
block_hits_to_break = 3; // Hits required to break block
block_break_timer = 0;
block_break_window = room_speed * 2.5; // 2.5 seconds to land all hits
is_blocking = false;
block_broken = false;
block_animation_timer = 0;
block_animation_duration = 20; // Block animation length

// Stunned state variables
stunned_timer = 0;
stunned_duration = room_speed * 2; // 2 seconds stunned when block breaks
flash = false;

// Hurt state variables
hurt_timer = 0;
hurt_duration = 20;
flash_duration = 10;
flash_timer = 0;

// Healt
hp = 2;

// Knockback variables
has_been_hit = false;
knockback_speed = 6;
knockback_duration = 15;
knockback_timer = 0;
previous_state = knightState.Patrol;

//Set sprites
hurt_sprite = sKnightHurt;
defeated_object = obj_fallen_knight_defeated;

// Combat state tracking
player_in_striking_range = false;
waiting_for_player_attack = false;
wait_timer = 0;
max_wait_time = room_speed * 1.5; // Wait 1.5 seconds for player to attack
has_attacked_this_encounter = false;