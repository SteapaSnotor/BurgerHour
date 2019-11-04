extends Node

"""
	Enemy Attacking state
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
	
	var dir = enemy.player.global_position - enemy.global_position
	dir = dir.normalized()
	if int(dir.x) != 0:
		enemy.move(Vector2(int(dir.x),0))
	
func input_update(event):
	pass

func transitions_update():
	#ATTACKING TO FALLING#
	if enemy.on_food and enemy.current_food != null:
		if enemy.current_food.is_falling:
			base.current_state = null
			base.queue_state = base.get_state('Falling')
			exit()
			return
	
	#ATTACKING TO SEARCHING#
	if (enemy.global_position.y-enemy.player.global_position.y) != 0 or not enemy.is_seeing_player:
		enemy.is_seeing_player = false
		base.current_state = null
		base.queue_state = base.get_state('Searching')
		exit()
	

#destructor
func exit():
	base = null
	enemy = null
	
	emit_signal('exited')




