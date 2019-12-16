extends Node2D

"""
	Handles the about/credits screen
"""

signal exited

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("exited")
		queue_free()