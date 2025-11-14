//animation end event for obj_enemy1 (goblin)
// Check if attack animation finished
if (sprite_index == sGoblinSlash && state == goblinState.Attack) {
    state = goblinState.Chase;
    // Reset attack cooldown 
    attack_cooldown = attack_cooldown_max;
    can_attack = true; // Reset can_attack to allow future attacks
}