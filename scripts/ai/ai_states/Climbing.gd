extends Node

"""
	Enemy Climbing state
"""

signal entered
signal exited

var base = null
var enemy = null
var direction = Vector2(0,0)
var ladder_tilemap = null
var dir = Vector2(0,0)
var checking_edge = false

#constructor
func initialize(base,enemy):
	self.base = base
	self.enemy = enemy
	self.enemy.set_z_index(self.enemy.base_z_index+1)
	self.ladder_tilemap = enemy.ladder_tiles
	
	var available_steps_above = 0  #tiles below the AI
	var available_steps_below = 0  #tiles above the AI
	var current_ladder = ladder_tilemap.world_to_map(enemy.global_position)
	
	for y in range(10):
		if ladder_tilemap.get_cell(current_ladder.x,current_ladder.y+y) != TileMap.INVALID_CELL:
			available_steps_below += 1 
		if ladder_tilemap.get_cell(current_ladder.x,current_ladder.y-y) != TileMap.INVALID_CELL:
			available_steps_above += 1 
	
	if available_steps_above <= 2: self.dir = Vector2(0,1)
	elif available_steps_below <= 2: self.dir = Vector2(0,-1)
	else:
		#can go up and down, do it randomly then
		self.dir = Vector2(0 ,1  -(int(rand_range(0,2)) * 2))
	#print('below: ' + str(available_steps_below))
	#print('above: ' + str(available_steps_above))
	self.enemy.global_position.x = ladder_tilemap.map_to_world(current_ladder).x+25
	emit_signal('entered')

func physics_update(delta):
	self.enemy.move(dir)
	
	if not checking_edge and not self.enemy.on_edge:
		checking_edge = true
		
	

func input_update(event):
	pass

func transitions_update():
	#CLIMBING TO SEARCHING#
	if self.enemy.on_edge and checking_edge:
		base.current_state = null
		base.queue_state = base.get_state('Searching')
		#closest floor tile
		var map_pos = enemy.floor_tiles.world_to_map(enemy.global_position)
		var world_pos = enemy.floor_tiles.map_to_world(map_pos)
		enemy.global_position = world_pos
		#apply offset
		enemy.global_position.x += 36
		enemy.global_position.y += 8
		exit()
	
#destructor
func exit():
	enemy.set_z_index(self.enemy.base_z_index-1)
	base = null
	enemy = null
	ladder_tilemap = null
	checking_edge = false
	dir = Vector2(0,0)
	emit_signal('exited')




