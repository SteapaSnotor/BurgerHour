extends Node2D

"""
	Plays the intro and starts the game main routine.
"""

func _ready():
	$Anim.connect('animation_finished',self,'start_main_routine')
	
func start_main_routine(anim):
	get_tree().change_scene_to(preload('res://scenes/Main.tscn'))
	pass