extends Node2D

"""
	Handles the pre-intro in the web version
"""

func start():
	get_tree().change_scene_to(preload('res://scenes/Intro.tscn'))