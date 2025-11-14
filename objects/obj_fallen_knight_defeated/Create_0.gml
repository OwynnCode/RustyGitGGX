// KNIGHT DEFEATED OBJECT - CREATE EVENT

sprite_index = sKnightDefeated;
image_index = 0;
image_speed = 1;

// Inherit basic physics if needed
vel_x = 0;
vel_y = 0;
grav_speed = 0.5;
grounded = false;

// Optional: Play death sound
if (audio_exists(snd_enemy_death)) {
    audio_play_sound(snd_enemy_death, 0, 0);
}