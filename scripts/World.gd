extends Node2D

"""
	Load levels and receives data from the level scene.
"""

#positions of enemies currently spawning
var spawning_positions = []
var current_level = null

#path for each level scene
var levels = {
	0:'res://scenes/Level0.tscn'
	
}

func load_level(id):
	if levels.keys().find(id) == -1:
		print('Level not found.')
		return
		
	var _scene = load(levels[id]).instance()
	current_level = _scene
	add_child(_scene,true)

func update_spawning_positions():
#	print(current_level.spawn_queue)
	pass

func exit_level():
	pass