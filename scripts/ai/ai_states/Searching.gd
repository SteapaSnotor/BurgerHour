extends Node

"""
	Enemy Searching state
"""

signal entered
signal exited

var base = null
var enemy = null
var dir = Vector2(0,0)

#constructor
func initialize(base,enemy):
	self.base = base
	self.enemy = enemy
	self.dir = Vector2(1  -(int(rand_range(0,2)) * 2) ,0)
	
	emit_signal('entered')

func physics_update(delta):
	if enemy == null: return
	
	enemy.move(dir)
	if enemy.get_slide_count() > 0:
		dir.x*= -1

func input_update(event):
	pass

func transitions_update():
	#SEARCHING TO CLIMBING#
	if enemy.on_ladder and base.last_state.name != 'Climbing':
		base.current_state = null
		base.queue_state = base.get_state('Climbing')
		exit()
	
	
	pass

#destructor
func exit():
	base = null
	enemy = null
	
	emit_signal('exited')




