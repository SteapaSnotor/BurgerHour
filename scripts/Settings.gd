extends Node

"""
	Store all the user settings/preferences in the game. Things like
	audio/music volume keyboard configuration etc...
"""

signal sound_changed
signal music_changed

var sound_volume = 50 setget set_sound_volume, get_sound_volume
var music_volume = 40 setget set_music_volume, get_music_volume

var no_music = false
var no_sound = false

var version = "1.0.0"

func set_sound_volume(value):
	sound_volume = value
	no_sound = sound_volume == 0
	emit_signal("sound_changed")

func get_sound_volume():
	return sound_volume
	
func set_music_volume(value):
	music_volume = value
	no_music = music_volume == 0
	emit_signal("music_changed")

func get_music_volume():
	return music_volume