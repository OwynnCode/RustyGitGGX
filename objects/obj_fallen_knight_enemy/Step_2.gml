// KNIGHT ENEMY - END STEP EVENT
event_inherited();

// Pixel-perfect collision handling
// X-axis collision
var _move_count = abs(vel_x);
var _move_once = sign(vel_x);

repeat (_move_count) {
    if (!check_collision(_move_once, 0)) {
        x += _move_once;
    } else {
        vel_x = 0;
        // If in patrol state and hit a wall, turn around
        if (state == knightState.Patrol) {
            patrol_dir = -patrol_dir;
        }
        break;
    }
}

// Y-axis collision
var _move_count = abs(vel_y);
var _move_once = sign(vel_y);

repeat (_move_count) {
    if (!check_collision(0, _move_once)) {
        y += _move_once;
    } else {
        vel_y = 0;
        break;
    }
}

// Additional turning logic for patrol state
if (state == knightState.Patrol) {
    // Check for walls ahead
    var _wall_found = check_collision(vel_x * 4, 0);
    if (_wall_found) {
        patrol_dir = -patrol_dir;
    }
    
    // Check for ledges ahead
    var _ground_ahead = check_collision(vel_x * 32, 64);
    if (!_ground_ahead && grounded) {
        patrol_dir = -patrol_dir;
    }
    
    // Check for other enemies
    var _inst = instance_place(x + vel_x * 16, y, obj_enemy_parent);
    if (_inst != noone) {
        patrol_dir = -patrol_dir;
    }
}