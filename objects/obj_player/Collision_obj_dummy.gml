// Check if this is a dummy - if so, don't take damage
if (variable_instance_exists(other, "is_dummy") && other.is_dummy) {
    // Do nothing - the dummy doesn't hurt the player
    exit; // Exit the event completely
}