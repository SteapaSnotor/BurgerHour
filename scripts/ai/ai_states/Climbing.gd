extends Node

"""
	Enemy Climbing state
"""

signal entered
signal exited

var base = null
var enemy = null
var direction = Vector2(0,-1)

#constructor
func initialize(base,enemy):
	self.base = base
	self.enemy = enemy
	
	var available_steps = 0
	
	
	emit_signal('entered')

func physics_update(delta):
	if enemy == null: return

func input_update(event):
	pass

func transitions_update():
	#CLIMBING TO SEARCHING#

	
	pass

#destructor
func exit():
	base = null
	enemy = null
	
	emit_signal('exited')




