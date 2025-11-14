//end step event for obj_harpy
/// @description End Step Event
// Run parent end step for basic collision handling
// But modify it for flying enemy behavior

// Pixel-perfect collision checking for X axis
var _move_count = abs(vel_x);
var _move_once = sign(vel_x);

repeat (_move_count)
{
    var _collision_found = check_collision(_move_once, 0);
    if (!_collision_found)
    {
        x += _move_once;
    }
    else
    {
        vel_x = 0;
        // If in patrol, reverse direction
        if (state == harpyState.Patrol) {
            patrol_dir = -patrol_dir;
            patrol_target_x = start_x + (patrol_dir * patrol_distance);
        }
        break;
    }
}

// Pixel-perfect collision checking for Y axis
var _move_count = abs(vel_y);
var _move_once = sign(vel_y);

repeat (_move_count)
{
    var _collision_found = check_collision(0, _move_once);
    if (!_collision_found)
    {
        y += _move_once;
    }
    else
    {
        vel_y = 0;
        break;
    }
}

// Keep harpy within vertical bounds
if (y < 50) {
    y = 50;
    vel_y = max(vel_y, 0); // Don't move up further
}
else if (y > room_height - 100) {
    y = room_height - 100;
    vel_y = min(vel_y, 0); // Don't move down further
}