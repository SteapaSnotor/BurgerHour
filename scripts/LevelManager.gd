extends Node2D

"""
	Manages the level. This includes spawning creatures, emiting signals
	when the player dies etc...
"""

var player

#tiles
onready var level_signals = $LevelSignals

#initialize the level
func _ready():
	spawn_player()

#spawn the player on this level
func spawn_player():
	player = preload('res://scenes/Player.tscn').instance()
	player.global_position = get_spawn_position()
	add_child(player)

#return the place where the player must spawn on this level
func get_spawn_position():
	var pos = level_signals.map_to_world(level_signals.get_used_cells_by_id(1)[0])
	#apply custom offset
	pos.x+= 28
	pos.y+= 8
	return pos
	
	





