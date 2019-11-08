extends Node2D

"""
	Load levels and receives data from the level scene.
"""

signal new_enemy
signal level_finished

var current_level = null
var new_enemy_data = {}
var lives = 3

#path for each level scene
var levels = {
	0:'res://scenes/Level0.tscn'
	
}

func load_level(id):
	if levels.keys().find(id) == -1:
		print('Level not found.')
		return false
		
	var _scene = load(levels[id]).instance()
	current_level = _scene
	add_child(_scene,true)
	
	#level signals
	_scene.connect('spawning',self,'on_enemy_spawn')
	
	return true

#restart the current loaded level
func restart_level():
	get_tree().reload_current_scene()
	pass

#when a new enemy is being spawn on the level scene
func on_enemy_spawn():
	new_enemy_data = current_level.spawning
	emit_signal("new_enemy")

func exit_level():
	pass