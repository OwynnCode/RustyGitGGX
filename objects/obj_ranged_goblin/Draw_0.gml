//draw event for obj_ranged_goblin
// Add flash effect when the enemy is hit
if (flash) {
    // Draw white version of the sprite to indicate damage
    gpu_set_fog(true, c_white, 0, 0);
    draw_self();
    gpu_set_fog(false, c_white, 0, 0);
} else {
    // Normal drawing
    draw_self();
}