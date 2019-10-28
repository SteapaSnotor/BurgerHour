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
	spawn_food()
	spawn_base()
	spawn_final_bases()
	randomize()#THIS SHOULD BE CALLED ON THE MAIN NODE. REMOVE IT FROM HERE LATER.

#spawn the player on this level
func spawn_player():
	player = preload('res://scenes/Player.tscn').instance()
	player.global_position = get_spawn_position()
	player.floor_tiles = $LevelMap
	player.ladder_tiles = $Ladders
	add_child(player)

#spawn all enemies on this level
func spawn_enemies():
	#TODO: spawn by id
	for enemie in $LevelSignals.get_used_cells_by_id(4):
		pass

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

#spawn all the food parts in game
func spawn_food():
	#TODO: check the id for different food parts
	for part in $Burger.get_used_cells():
		var world_pos = $Burger.map_to_world(part)
		var food = preload('res://scenes/FoodPart.tscn').instance()
		add_child(food)
		#TODO: sprite must always be 192x64 for this to work...
		food.global_position = world_pos
		food.global_position.x +=96+$Burger.global_position.x
		food.global_position.y +=32+$Burger.global_position.y
		food.init()
	
#spawn all solid bases the food will fall
func spawn_base():
	for tile in $LevelSignals.get_used_cells_by_id(3):
		var world_pos = $LevelSignals.map_to_world(tile)
		var base = preload('res://scenes/BurgerBase.tscn').instance()
		add_child(base)
		base.global_position = world_pos
		#aplly offset
		base.global_position.x += 25
		base.global_position.y += 11

#spawn the final bases where the food should fall
func spawn_final_bases():
	for tile in $LevelMap.get_used_cells_by_id(1):
		var detection = preload('res://scenes/FinalBaseDetection.tscn').instance()
		add_child(detection)
		detection.global_position = $LevelMap.map_to_world(tile)
		#apply offset
		detection.global_position.x += 29
		detection.global_position.y += 16
 
#return the place where the player must spawn on this level
func get_spawn_position():
	var pos = level_signals.map_to_world(level_signals.get_used_cells_by_id(1)[0])
	#apply custom offset
	pos.x+= 28
	pos.y+= 8
	return pos

func get_ladder_tiles():
	return $Ladders.get_used_cells()
	





