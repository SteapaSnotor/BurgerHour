extends Node2D

"""
	Load levels and receives data from the level scene.
"""

signal new_enemy
signal level_finished
signal level_reloaded
signal new_score
signal new_spray_count
signal loading_level
signal reloading_level
signal level_loaded

var current_level = null
var current_level_id = -1
var new_enemy_data = {}
var lives = 3
var sprays = 3
var level_new_score = 0
var level_old_score = 0
var bonus_points = 0
var spray_points = 0
var live_points = 0


#world rules
const max_lives = 3
const max_sprays = 3

#path for each level scene
var levels = {
	0:'res://scenes/Level0.tscn',
	1:'res://scenes/Level1.tscn'
	
}

func load_level(id):
	if levels.keys().find(id) == -1:
		print('Level not found.')
		return false
	emit_signal("loading_level")
	#var _scene = load(levels[id]).instance()
	var _scene = null
	var loader = load('res://scenes/LoadingScreen.tscn').instance()
	add_child(loader)
	loader.init(levels[id])
	yield(loader,'loaded')
	_scene = loader.get_level()
	loader.queue_free()
	
	current_level_id = id
	current_level = _scene
	level_new_score = 0
	level_old_score = 0
	bonus_points = 0
	spray_points = 0
	live_points = 0
	add_child(_scene,true)
	
	#level signals
	_scene.connect('spawning',self,'on_enemy_spawn')
	_scene.connect('new_points',self,'on_new_score')
	
	#scene properties
	_scene.sprays = sprays
	if sprays == 0: _scene.player.has_sprays = false
	
	emit_signal('level_loaded')
	
	return true

#restart the current loaded level
func restart_level():
	emit_signal("reloading_level")
	var _current_id = current_level_id
	exit_level()
	load_level(_current_id)
	yield(self,'level_loaded')
	emit_signal("level_reloaded")

func pause_game():
	get_tree().paused = true

func resume_game():
	get_tree().paused = false

#when a new enemy is being spawn on the level scene
func on_enemy_spawn():
	new_enemy_data = current_level.spawning
	emit_signal("new_enemy")

func on_new_score():
	level_old_score = level_new_score
	level_new_score += current_level.new_points
	emit_signal("new_score")

func exit_level():
	current_level.call_deferred('free')
	current_level = null
	current_level_id = -1