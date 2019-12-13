extends Node

"""
	Handles all the sound effects and music in the game.
"""

#initialize
func init():
	Settings.connect('sound_changed',self,'update_sound_volume')
	Settings.connect('music_changed',self,'update_music_volume')
	
	update_sound_volume()
	update_music_volume()
	
func play_sound():
	pass
	
func play_music():
	pass

#updates the volume of all sound effects in game
func update_sound_volume():
	pass
	
func update_music_volume():
	#print(lerp(-10,10,0.5))
	pass














