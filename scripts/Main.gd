extends Node

"""
	Manages the game
"""

var score = {
	0:0
}

var _world = null
var _gui = null
var selected_level = 0

#initialize all the game here
func _ready():
	_world = $World
	_gui = $GUI
	
	#TODO: don't init the world at the start of the game
	init_world()
	init_gui()
	
	#TODO: loads the main menu instead
	randomize()
	
func init_world():
	_world.connect('new_enemy',self,'on_new_enemy')
	_world.load_level(selected_level)
	
func init_gui():
	_gui.init(score[selected_level])

#when there's a new enemy on the game
func on_new_enemy():
	_gui.spawning_arrow(_world.new_enemy_data['at'],_world.new_enemy_data['time'])






