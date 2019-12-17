extends Node2D

"""
	Handles the Hall of fame Menu screen. It Just show a score 
	from newgrounds or from the computer.
"""

signal exited

const max_char = 61

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("exited")
		queue_free()