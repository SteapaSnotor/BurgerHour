extends Node

"""
	Player TotallyDead state
"""

signal entered
signal exited

var base

#constructor
func initialize(base,player):
	self.base = base
	
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

