extends Node

"""
	Handles all the sound effects and music in the game.
"""

var current_fading = null

const fade_min_threshold = -20

#initialize
func init():
	Settings.connect('sound_changed',self,'update_sound_volume')
	Settings.connect('music_changed',self,'update_music_volume')
	
	update_sound_volume()
	update_music_volume()
	
func play_sound(sound,solo=false):
	if solo:stop_sound()
	$Sound.get_node(sound).play()
	
func play_music(music,solo=true):
	if solo: stop_music()
	$Music.get_node(music).play()
	

#updates the volume of all sound effects in game
func update_sound_volume():
	if Settings.no_sound: return mute_sound()
	
func update_music_volume():
	if Settings.no_music: return mute_music()
	
	for music in $Music.get_children():
		music.set_volume_db(lerp(-15,15,float(Settings.get_music_volume())/100.0))
		
	#print(lerp(-10,10,float(Settings.get_music_volume())/100.0))

#mutes all musics that are currently playing
func mute_music():
	for music in $Music.get_children():
		music.set_volume_db(-500)

#mutes all sounds that are currently playing
func mute_sound():
	pass

#stop one or all musics in the game
func stop_music(_music=null,fade=false):
	if _music != null:
		if not fade:
			$Music.get_node(_music).stop()
		else:
			current_fading = $Music.get_node(_music)
			
		return
		
	for music in $Music.get_children():
			music.stop()

#stop one or all sounds in the game
func stop_sound(_sound=null):
	if _sound != null:
		$Sound.get_node(_sound).stop()
		return
	
	for sound in $Sound.get_children():
		sound.stop()
	
func fade_click():
	if current_fading != null:
		current_fading.set_volume_db(current_fading.get_volume_db()-1)
		if current_fading.get_volume_db() < fade_min_threshold:
			current_fading.stop()
			update_music_volume()
			current_fading = null







