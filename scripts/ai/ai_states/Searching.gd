extends Node

"""
	Enemy Searching state
"""

signal entered
signal exited

var base = null
var enemy = null
var dir = Vector2(0,0)
var idle = false

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
		
		if not base.last_state.name == 'idle': idle = true

func input_update(event):
	pass

func transitions_update():
	#SEARCHING TO CLIMBING#
	if enemy.on_ladder and base.last_state.name != 'Climbing':
		base.current_state = null
		base.queue_state = base.get_state('Climbing')
		exit()
	elif idle:
		base.current_state = null
		base.queue_state = base.get_state('Idle')
		exit()
	else: return

#destructor
func exit():
	base = null
	enemy = null
	idle = false
	
	emit_signal('exited')




