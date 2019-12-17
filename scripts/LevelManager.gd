extends Node2D

"""
	Manages the level. This includes spawning creatures, emiting signals
	when the player dies etc...
"""

signal spawning
signal finished
signal player_hit
signal player_died
signal player_sprayed
signal new_points
signal new_lives
signal new_sprays
signal food_hit
signal player_broke_food

var player
var spawning = {} #data of the last enemy to start to spawn on the level
var food_count = 0
var new_points = 0
var new_lives = 0
var new_sprays=0
var new_points_position = Vector2(0,0)
var new_lives_position = Vector2(0,0)
var new_sprays_position = Vector2(0,0)
var sprays = 3 #decrease on check_player_state()
var finished = false

#enemies ID's according to each tile
var enemies_data = {4:0,5:1,6:2}

#tiles
onready var level_signals = $LevelSignals
onready var tree = get_tree()

export var spawn_interval = 2.0
export var powerup_click_interval = 4.0
export var music = 'Jazz1'

#initialize the level
func _ready():
	spawn_player()
	spawn_ladder()
	spawn_edges()
	spawn_food()
	spawn_base()
	spawn_enemies()
	spawn_final_bases()
	spawn_powerups()
	spawn_clouds()
	randomize()#THIS SHOULD BE CALLED ON THE MAIN NODE. REMOVE IT FROM HERE LATER.
	
#spawn the player on this level
func spawn_player():
	player = preload('res://scenes/Player.tscn').instance()
	player.global_position = get_spawn_position()
	player.floor_tiles = $LevelMap
	player.ladder_tiles = $Ladders
	add_child(player)
	player.FSM.connect('changed_state',self,'check_player_state')

#spawn enemies along the level
func spawn_enemies(_signal={},spawn=false,_timer=null):
	if _signal.values() == []:
		#first time spawn
		var spawns = 0
		var spawn_time = spawn_interval
		var signal_dict  = {'spawns':[],'time':[],'tile':[]}
		var tiles = $LevelSignals.get_used_cells_by_id(4) + $LevelSignals.get_used_cells_by_id(5)
		tiles = tiles + $LevelSignals.get_used_cells_by_id(6)
		for tile in tiles:
			#TODO: id
			signal_dict['spawns'] = spawns
			signal_dict['time'].append(spawn_time)
			signal_dict['tile'].append(tile)
			
			spawns += 1
			spawn_time += spawn_interval/2.0
		signal_dict['time'].invert()
		spawn_enemies(signal_dict)
	elif not spawn: #use _signal information to spawn
		#timer that controls the interval between spawns
		var timer = Timer.new()
		timer.connect('timeout',self,'spawn_enemies',[_signal,true,timer])
		timer.set_wait_time(_signal['time'][_signal['spawns']])
		timer.name = 'SpawnTimer'
		timer.one_shot = true
		$LevelSignals.add_child(timer)
		timer.start()
		spawning = {'at':$LevelSignals.map_to_world(_signal['tile'][_signal['spawns']]),'time':_signal['time'][_signal['spawns']]+spawn_interval}
		call_deferred('emit_signal','spawning')
	else:
		var enemy = preload('res://scenes/Enemy.tscn').instance()
		enemy.ladder_tiles = $Ladders
		enemy.floor_tiles = $LevelMap
		enemy.global_position = $LevelSignals.map_to_world(_signal['tile'][_signal['spawns']])
		enemy.id = enemies_data[$LevelSignals.get_cellv(_signal['tile'][_signal['spawns']])]
		add_child(enemy)
		enemy.finished = finished
		#apply custom offset for enemies
		enemy.global_position.x+= 28
		enemy.global_position.y+= 8
		
		#enemy respawning
		var _spawn_dict = {}
		_spawn_dict['spawns'] = 0
		_spawn_dict['time'] = [spawn_interval*2]
		_spawn_dict['tile'] = [$LevelSignals.world_to_map(enemy.global_position)]
		enemy.connect('died',self,'spawn_enemies',[_spawn_dict,false])
		enemy.connect('died',self,'add_points',[100,enemy])
		enemy.connect('fall',self,'add_points',[500,enemy])
		enemy.connect('sprayed',self,'add_points',[50,enemy])
		enemy.connect('sprayed',self,'spawn_enemies',[_spawn_dict,false])
		connect('finished',enemy,'set_level_finished',[true])
		_timer.queue_free()
		#$LevelSignals.get_child(0).queue_free() -< BAD BUG
		
		var new_dict = _signal
		new_dict['spawns']-= 1
		
		if new_dict['spawns'] != -1:
			spawn_enemies(new_dict)
 		
		
	""" Old method of spawning without "queues":
	#TODO: spawn by id
	for tile in $LevelSignals.get_used_cells_by_id(4):
		var enemy = preload('res://scenes/Enemy.tscn').instance()
		enemy.ladder_tiles = $Ladders
		enemy.floor_tiles = $LevelMap
		add_child(enemy)
		enemy.global_position = $LevelSignals.map_to_world(tile)
		#apply custom offset for enemies
		enemy.global_position.x+= 28
		enemy.global_position.y+= 8
	"""

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
		food_count += 1
		#TODO: sprite must always be 192x64 for this to work...
		food.global_position = world_pos
		food.global_position.x +=96+$Burger.global_position.x
		food.global_position.y +=32+$Burger.global_position.y
		food.init($Burger.get_cell(part.x,part.y))
		food.connect('on_final_base',self,'check_level_progress')
		food.connect('hit',self,'check_food_state',['hit'])
		food.connect('player_broke',self,'check_food_state',['player_broke'])
		food.connect('broke_free',self,'add_points',[10,food])
	
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
 
#try to spawn a power-up on the level from time to time.
func spawn_powerups(_timer = null):
	if _timer == null:
		#initialize the power-up timer
		var timer = Timer.new()
		timer.name = 'PowerUpTimer'
		timer.connect("timeout",self,"spawn_powerups",[timer])
		add_child(timer)
		timer.wait_time = powerup_click_interval
		timer.start()
	else:
		if get_powerup_count() >=2: return 
		if finished: return
		
		var r = rand_range(0,100)
		
		if r > 82: #18%
			var power_up = preload('res://scenes/PowerUps.tscn').instance()
			var random_tile = get_floor_tiles()
			random_tile.shuffle()
			add_child(power_up)
			power_up.init($LevelMap.map_to_world(random_tile[0]),self)

func spawn_clouds():
	$LevelMap.hide() 
	var tiles = $LevelMap.get_used_cells_by_id(0) + $LevelMap.get_used_cells_by_id(1)
	for tile in tiles:
		#TODO: spawn final base tiles texture
		var _c_text = preload('res://scenes/CloudTexture.tscn').instance()
		add_child(_c_text)
		_c_text.global_position = Vector2($LevelMap.map_to_world(tile).x+30,$LevelMap.map_to_world(tile).y+15)
		_c_text.set_z_index(-1)
		

#return the place where the player must spawn on this level
func get_spawn_position():
	var pos = level_signals.map_to_world(level_signals.get_used_cells_by_id(1)[0])
	#apply custom offset
	pos.x+= 28
	pos.y+= 8
	return pos

func get_ladder_tiles():
	return $Ladders.get_used_cells()

func get_floor_tiles():
	return $LevelMap.get_used_cells()

#returns the amount of powerups currently on the level
func get_powerup_count():
	return tree.get_nodes_in_group("PowerUp").size()

#check if the level has been finished
func check_level_progress():
	food_count -= 1
	if food_count == 0 and player.is_player_alive(): 
		emit_signal("finished")
		finished = true

#detect some events through the player's states.
func check_player_state():
	#check if the player died and the level is over
	if player.FSM.get_current_state().name == 'TotallyDead':
		emit_signal("player_died")
	elif player.FSM.get_current_state().name == 'Dead':
		emit_signal("player_hit")
	elif player.FSM.get_current_state().name == 'Spraying':
		sprays-= 1
		if sprays == 0: player.has_sprays = false
		emit_signal("player_sprayed")

#detect some events that happen to the food parts
func check_food_state(event):
	match event:
		'hit':
			emit_signal("food_hit")
		'player_broke':
			emit_signal("player_broke_food")

#add points to the level score
func add_points(value,at=Vector2(0,0)):
	new_points = value
	if at is Vector2:
		new_points_position = at
	else: new_points_position = at.global_position #position as object
	emit_signal("new_points")

func add_lives(value,at=Vector2(0,0)):
	new_lives = value
	new_lives_position = at
	emit_signal("new_lives")

func add_sprays(value,at=Vector2(0,0)):
	new_sprays = value
	new_sprays_position = at
	player.has_sprays = true
	emit_signal("new_sprays")



