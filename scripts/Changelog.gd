extends Node2D

"""
	Display the changelog text.
"""

signal exited

func _ready():
	var file = File.new()
	file.open('res://Changelog.txt',File.READ)
	var txt = file.get_as_text()
	$History.text = txt
	
func _input(event):
	if event.is_action("ui_cancel"):
		emit_signal("exited")
		queue_free()