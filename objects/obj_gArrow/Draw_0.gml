//draw event for obj_gArrow
// Draw the arrow
draw_self();

// Optional: add a trail effect
if (!has_hit) {
    var trail_length = 3;
    var alpha_step = 0.2;
    
    // Draw ghost images with decreasing alpha
    for (var i = 1; i <= trail_length; i++) {
        var trail_x = x - (speed_x * facing * i);
        var trail_y = y - (speed_y * i);
        var trail_alpha = 1 - (alpha_step * i);
        
        draw_sprite_ext(
            sprite_index, 
            image_index, 
            trail_x, 
            trail_y, 
            image_xscale, 
            image_yscale, 
            image_angle, 
            c_white, 
            trail_alpha
        );
    }
}

