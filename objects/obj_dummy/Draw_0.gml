//draw event
// Regular draw
if (!flash) {
    draw_self();
} 
// Draw with flash effect
else {
    // Simple white flash effect that doesn't require a shader
    // Draw the sprite normally
    draw_self();
    
    // Draw white overlay with alpha
    var old_alpha = draw_get_alpha();
    draw_set_alpha(flash_alpha);
    draw_set_color(c_white);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(old_alpha);
    draw_set_color(c_white);
}