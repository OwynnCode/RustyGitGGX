//end step event for obj_enemy1 (goblin)
/// @description End Step Event
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