//alarm 0 event for obj_ranged_goblin
// Force immediate chase behavior
if (state == goblinState.Chase) {
    // Recalculate position relative to player
    if (instance_exists(obj_player)) {
        var distance_to_player = point_distance(x, y, obj_player.x, obj_player.y);
        var dir_to_player = sign(obj_player.x - x);
        
        // If too close to player, move away
        if (distance_to_player < retreat_range) {
            vel_x = -dir_to_player * chase_speed;
        }
        // If within chase range but not attack range, move toward player but maintain ideal distance
        else if (distance_to_player <= chase_range) {
            if (distance_to_player < ideal_distance - 10) {
                // Too close, back away slightly
                vel_x = -dir_to_player * chase_speed * 0.7;
            } 
            else if (distance_to_player > ideal_distance + 10) {
                // Too far, approach player
                vel_x = dir_to_player * chase_speed;
            }
            else {
                // At ideal distance, stop moving
                vel_x = 0;
            }
        }
        // If outside chase range, return to patrol
        else {
            state = goblinState.Patrol;
            patrol_time = 0;
        }
    }
}