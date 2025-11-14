//create event
event_inherited();
// This is the amount of damage the enemy does to the player.
damage = 1;
// This sets the movement speed for the enemies.
move_speed = 2;
// This applies either move_speed or negative move_speed to the enemy's X velocity. This waythe enemy will
// either move left or right (at random).
vel_x = choose(-move_speed, move_speed);
// This sets the friction to 0 so the enemy never comes to a stop.
friction_power = 0;

// Add these new variables for knockback and hit reactions
has_been_hit = false;           // Flag for tracking if enemy was just hit
knockback_speed = 5;            // Initial knockback speed
knockback_duration = 15;        // Frames for knockback effect
knockback_timer = 0;            // Current knockback timer
flash = false;                  // Visual hit feedback
flash_duration = 10;            // How long to flash
flash_timer = 0;                // Current flash timer
hurt_duration = 20;             // Duration for hurt state
hurt_timer = 0;                 // Timer for hurt state
hurt_sprite = sGoblinHurt;      // Default hurt sprite (override in child objects)
previous_state = "";            // Store previous state to return to