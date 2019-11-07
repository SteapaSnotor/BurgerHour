extends Node

"""
	Enemy Idle state
"""

signal entered
signal exited

var base = null
var enemy = null

#constructor
func initialize(base,enemy):
	self.base = base
	self.enemy = enemy
	emit_signal('entered')

func physics_update(delta):
	if enemy == null: return

func input_update(event):
	pass

func transitions_update():
	#IDLE TO SEARCHING#
	if not enemy.finished:
		base.current_state = null
		base.queue_state = base.get_state('Searching')
		exit()
	
#destructor
func exit():
	base = null
	enemy = null
	
	emit_signal('exited')




