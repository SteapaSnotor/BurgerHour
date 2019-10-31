extends Node

"""
	Player Dead state
"""

signal entered
signal exited

var player = null
var walk_input = false
var climb_input = false
var spray_input = false
var base = null
var y_offset = false

#constructor
func initialize(base,player):
	self.base = base
	self.player = player
	
	#the animations on this state have a slight offset
	if player.facing_dir == Vector2(0,0):
		player.anim_node.global_position.x+=10
		player.anim_node.global_position.y+=5
		y_offset = true
	else:
		player.anim_node.global_position.y+=2
	
	emit_signal('entered')

func physics_update(delta):
	if climb_input and player.facing_dir != Vector2(0,0):
		player.facing_dir = Vector2(0,0)
		if not y_offset: 
			player.anim_node.global_position.y+=3
			player.anim_node.global_position.x+=10

func input_update(event):
	walk_input = player.get_walk_keys().has(true)
	climb_input = player.get_climb_keys().has(true)

func transitions_update():
	#DEAD-END#
	pass

#destructor
func exit():
	if player.facing_dir == Vector2(0,0):
		player.anim_node.global_position.x-=10
		player.anim_node.global_position.y-=5
	else: 	player.anim_node.global_position.y-=2
	player = null
	walk_input = false
	spray_input = false
	base = null
	climb_input = false
	y_offset = false
	
	emit_signal('exited')
