extends Node

"""
	Player Idle state
"""

signal entered
signal exited

var base = null
var player = null
var animation_ended = false setget set_animation_ended
var spray_dir = Vector2(0,0)
var sprayed = false

const spray_frame = 7

#constructor
func initialize(base,player):
	self.base = base
	self.player = player
	
	self.player.anim_node.connect('animation_finished',self,'set_animation_ended',[true])
	self.player.anim_node.connect('frame_changed',self,'check_spray_frame')
	
	var spray_dir = player.facing_dir
	if spray_dir.x != 1 and spray_dir.x != -1: spray_dir.x =1
	self.player.facing_dir = spray_dir
	
	#the animations on this state have a slight offset
	player.anim_node.global_position.y+=2
	
	emit_signal('entered')

func physics_update(delta):
	pass

func input_update(event):
	pass

func transitions_update():
	#SPRAYING TO IDLE#
	if animation_ended:
		base.current_state = null
		base.queue_state = base.get_state('Idle')
		exit()

func set_animation_ended(value):
	animation_ended = value

#when the animation is in the right frame, spawn the smoke.
func check_spray_frame():
	if player.anim_node.get_frame() == spray_frame and not sprayed:
		self.player.spawn_smoke(player.facing_dir)
		self.sprayed = true

#destructor
func exit():
	player.anim_node.disconnect('animation_finished',self,'set_animation_ended')
	player.anim_node.disconnect('frame_changed',self,'check_spray_frame')
	player.anim_node.global_position.y-=2
	player = null
	base = null
	animation_ended = false
	sprayed = false
	spray_dir = Vector2(0,0)
	emit_signal('exited')
	
