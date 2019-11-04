extends Node

"""
	Manages the game
"""

var _world = null
var _gui = null
var selected_level = 0

#initialize all the game here
func _ready():
	_world = $World
	_gui = $GUI
	
	#TODO: loads the main menu instead
	_world.load_level(selected_level)
	randomize()