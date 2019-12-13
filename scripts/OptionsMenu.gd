extends Node2D

"""
	Handles the options menu scene. It changes things on the settings
	singleton.
"""

signal exited

#load data from the settings singleton
func _ready():
	pass

func exit():
	emit_signal("exited")
	queue_free()
	
func increase_audio():
	$AudioBar.set_value($AudioBar.get_value()+10)
	
func decrease_audio():
	$AudioBar.set_value($AudioBar.get_value()-10)
	
func increase_music():
	$MusicBar.set_value($MusicBar.get_value()+10)

func decrease_music():
	$MusicBar.set_value($MusicBar.get_value()-10)







