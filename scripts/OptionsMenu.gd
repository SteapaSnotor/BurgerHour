extends Node2D

"""
	Handles the options menu scene. It changes things on the settings
	singleton.
"""

signal exited

#load data from the settings singleton
func _ready():
	$AudioBar.set_value(Settings.get_sound_volume())
	$MusicBar.set_value(Settings.get_music_volume())

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		self.exit()

func exit():
	emit_signal("exited")
	queue_free()
	
func increase_audio():
	$AudioBar.set_value($AudioBar.get_value()+10)
	Settings.set_sound_volume($AudioBar.get_value())
	
func decrease_audio():
	$AudioBar.set_value($AudioBar.get_value()-10)
	Settings.set_sound_volume($AudioBar.get_value())
	
func increase_music():
	$MusicBar.set_value($MusicBar.get_value()+10)
	Settings.set_music_volume($MusicBar.get_value())

func decrease_music():
	$MusicBar.set_value($MusicBar.get_value()-10)
	Settings.set_music_volume($MusicBar.get_value())







