// Create Event for obj_effect_hit
image_speed = 0.5;

// Step Event for obj_effect_hit
// Destroy when animation ends
if (image_index >= image_number - 1) {
    instance_destroy();
}

