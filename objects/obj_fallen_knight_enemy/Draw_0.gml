// KNIGHT ENEMY - DRAW EVENT

// Flash effect when the enemy is hit or in certain states
var should_flash = false;
var flash_intensity = c_white; // Default flash color

// Flash when hurt
if (flash && flash_timer > 0) {
    should_flash = true;
    flash_intensity = c_white;
}

// Enhanced flash when stunned
if (state == knightState.Stunned) {
    // Continuous flashing while stunned
    var flash_cycle = floor(stunned_timer / 5) % 2; // Changes every 5 frames
    should_flash = (flash_cycle == 0);
    flash_intensity = c_yellow; // Use yellow flash for stunned state
}

// Brief flash when block is hit
if (block_animation_timer > 0 && state == knightState.Block) {
    should_flash = (block_animation_timer % 4 < 2); // Quick flash
    flash_intensity = c_ltgray; // Light gray flash for block
}

// Flash when taking damage during hurt state
if (state == knightState.Hurt && knockback_timer > 0) {
    should_flash = (knockback_timer % 6 < 3); // Flash during knockback
    flash_intensity = c_red; // Red flash for damage
}

// Enhanced flash for block break moment
if (block_broken && stunned_timer > (stunned_duration - 30)) {
    // Strong flash for first 30 frames of stun after block break
    should_flash = ((stunned_duration - stunned_timer) % 3 < 1.5); // Rapid flash
    flash_intensity = c_orange; // Orange flash for block break
}

// Draw the sprite with or without flash effect
if (should_flash) {
    // Draw colored version of the sprite to indicate different states
    gpu_set_fog(true, flash_intensity, 0, 0);
    draw_self();
    gpu_set_fog(false, flash_intensity, 0, 0);
} else {
    // Normal drawing
    draw_self();
}

// Draw additional visual indicators for debugging or feedback
#region Optional Visual Indicators

// Draw block hit counter when blocking
if (state == knightState.Block && block_hits > 0) {
    draw_set_color(c_red);
    draw_set_font(-1);
    var hit_text = string(block_hits) + "/" + string(block_hits_to_break);
    var text_x = x - string_width(hit_text) / 2;
    var text_y = y - 45;
    
    // Draw background for text
    draw_set_color(c_black);
    draw_rectangle(text_x - 2, text_y - 2, text_x + string_width(hit_text) + 2, text_y + string_height(hit_text) + 2, false);
    
    // Draw text
    draw_set_color(c_red);
    draw_text(text_x, text_y, hit_text);
    draw_set_color(c_white);
}

// Draw stun timer when stunned
if (state == knightState.Stunned) {
    draw_set_color(c_yellow);
    draw_set_font(-1);
    var stun_text = "STUNNED";
    var text_x = x - string_width(stun_text) / 2;
    var text_y = y - 35;
    
    // Draw background for text
    draw_set_color(c_black);
    draw_rectangle(text_x - 2, text_y - 2, text_x + string_width(stun_text) + 2, text_y + string_height(stun_text) + 2, false);
    
    // Draw text
    draw_set_color(c_yellow);
    draw_text(text_x, text_y, stun_text);
    draw_set_color(c_white);
}
#endregion