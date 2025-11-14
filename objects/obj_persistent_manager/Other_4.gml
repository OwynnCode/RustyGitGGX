//room start event
// Play different music tracks based on the current room
// First stop any currently playing music to avoid overlapping
audio_stop_sound(snd_music_level);
audio_stop_sound(snd_music_level_2);
audio_stop_sound(snd_music_level_3);

// Menu and training rooms - play music level 1
if (room == rm_menu || room == rm_training_1 || room == rm_training_2 || room == rm_end)
{
    audio_play_sound(snd_music_level, 0, true);
}
// Forest rooms - play music level 2
else if (room == rm_forest_1 || room == rm_forest_2)
{
    audio_play_sound(snd_music_level_2, 0, true);
}
// Mountain room - play music level 3
else if (room == rm_mountain_1)
{
    audio_play_sound(snd_music_level_3, 0, true);
}