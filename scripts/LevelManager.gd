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
	spawn_ladder()
	spawn_edges()

#spawn the player on this level
func spawn_player():
	player = preload('res://scenes/Player.tscn').instance()
	player.global_position = get_spawn_position()
	player.floor_tiles = $LevelMap
	player.ladder_tiles = $Ladders
	add_child(player)
	
#spawn ladders detection areas
func spawn_ladder():
	for tile in $Ladders.get_used_cells():
		var detection = preload('res://scenes/LadderDetection.tscn').instance()
		add_child(detection)
		detection.global_position = $Ladders.map_to_world(tile)
		#ladder offset
		detection.global_position.x += 23.5
		detection.global_position.y += 31

#spawn edges of the floor
func spawn_edges():
	for tile in $LevelSignals.get_used_cells_by_id(2):
		var detection = preload('res://scenes/FloorDetection.tscn').instance()
		add_child(detection)
		detection.global_position = $LevelSignals.map_to_world(tile)
		#edge offset
		detection.global_position.x += 42

#return the place where the player must spawn on this level
func get_spawn_position():
	var pos = level_signals.map_to_world(level_signals.get_used_cells_by_id(1)[0])
	#apply custom offset
	pos.x+= 28
	pos.y+= 8
	return pos

func get_ladder_tiles():
	return $Ladders.get_used_cells()
	





