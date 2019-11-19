extends Node

"""
	Player Idle state
"""

signal entered
signal exited

var base = null
var player = null

#constructor
func initialize(base,player):
	self.base = base
	self.player = player
	
	emit_signal('entered')

func physics_update(delta):
	pass

func input_update(event):
	pass

func transitions_update():
	#SPRAYING TO IDLE#
	pass

#destructor
func exit():
	player = null
	base = null
	
	emit_signal('exited')
	