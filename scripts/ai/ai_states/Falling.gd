extends Node

"""
	Enemy Falling state
"""

signal entered
signal exited

var base = null
var enemy = null
var initial_y = 0

#constructor
func initialize(base,enemy):
	self.base = base
	self.initial_y = enemy.global_position.y - enemy.current_food.global_position.y
	self.enemy = enemy
	emit_signal('entered')

func physics_update(delta):
	if enemy == null: return
	
	enemy.global_position.y = enemy.current_food.global_position.y+initial_y

func input_update(event):
	pass

func transitions_update():
	#DEAD END#
	if not enemy.current_food.is_falling: enemy.call_deferred('free')
	return
	

#destructor
func exit():
	base = null
	enemy = null
	initial_y = 0
	
	emit_signal('exited')




