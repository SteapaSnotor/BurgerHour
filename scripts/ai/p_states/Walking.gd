extends Node

"""
	Player Walking state
"""

signal entered
signal exited

var base
var player
var walk_input = false
var climb_input = false
var spray_input = false

#constructor
func initialize(base,player):
	self.base = base
	self.player = player
	
	emit_signal('entered')

func physics_update(delta):
	walk_input = player.get_walk_keys().has(true)
	climb_input = player.get_climb_keys().has(true)
	if not walk_input or climb_input: return
	
	var move_dir = -int(player.get_walk_keys()[0]) + int(player.get_walk_keys()[1])
	player.move(Vector2(move_dir,0))
	
func input_update(event):
	pass

func transitions_update():
	#WALKING TO IDLE#
	if not walk_input and not spray_input:
		base.current_state = null
		base.queue_state = base.get_state('Idle')
		exit()
	#WALKING TO CLIMBING
	if climb_input and player.on_ladder:
		base.current_state = null
		player.facing_dir = Vector2(0,0)
		base.queue_state = base.get_state('Climbing')
		exit()
	else: 
		return

#destructor
func exit():
	base = null
	player = null
	walk_input = false
	spray_input = false
	climb_input = false
	
	emit_signal('exited')