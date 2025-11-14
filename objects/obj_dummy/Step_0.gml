//step event
event_inherited();

// Handle flash timer
if (flash) {
    flash_timer--;
    if (flash_timer <= 0) {
        flash = false;
    }
}

// Process collision - handle falling but prevent movement
var _move_count = abs(vel_y);
var _move_once = sign(vel_y);

repeat (_move_count) {
    var _collision_found = check_collision(0, _move_once);
    if (!_collision_found) {
        y += _move_once;
    } else {
        vel_y = 0;
        break;
    }
}
