extends Node

"""
	Player climbing state
"""

signal entered
signal exited

var base = null
var player = null
var ladder_position = null
var climb_input = false
var walk_input = false

#constructor
func initialize(base,player):
	self.base = base
	self.player = player
	self.player.set_z_index(2)
	self.player.global_position.x = self.player.ladder_pos.x
	
	emit_signal('entered')

func physics_update(delta):
	climb_input = player.get_climb_keys().has(true)
	walk_input = player.get_walk_keys().has(true)
	
	var move_dir = -int(player.get_climb_keys()[0]) + int(player.get_climb_keys()[1])
	player.move(Vector2(0,move_dir))
	

func input_update(event):
	pass

func transitions_update():
	#CLIMBING TO WALKING#
	if walk_input and not climb_input and player.on_edge:
		base.current_state = null
		base.queue_state = base.get_state('Walking')
		#go to the closest tile
		var map_pos = player.floor_tiles.world_to_map(player.global_position)
		var world_pos = player.floor_tiles.map_to_world(map_pos)
		player.global_position = world_pos
		#apply offset
		player.global_position.x += 28
		player.global_position.y += 8
		
		exit()

#destructor
func exit():
	self.player.set_z_index(player.base_z_index)
	self.base = null
	self.player = null
	self.climb_input = false
	self.walk_input = false
	emit_signal('exited')