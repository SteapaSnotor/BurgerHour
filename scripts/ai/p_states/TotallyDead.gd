extends Node

"""
	Player TotallyDead state
"""

signal entered
signal exited

var base
var player

#constructor
func initialize(base,player):
	self.base = base
	self.player = player
	
	player.anim_node.global_position.y+=15
	emit_signal('entered')

func physics_update(delta):
	pass

func input_update(event):
	pass


func transitions_update():
	#DEAD-END
	pass

#destructor
func exit():
	base = null
	
	emit_signal('exited')

