extends Node

"""
	Enemy Stunned state
"""

signal entered
signal exited

var base = null
var enemy = null
var animation_finished = false

#constructor
func initialize(base,enemy):
	self.base = base
	self.enemy = enemy
	self.enemy.anim_node.connect('animation_finished',self,'animation_ended')
	emit_signal('entered')

func physics_update(delta):
	if enemy == null: return

func animation_ended():
	animation_finished = true

func input_update(event):
	pass

func transitions_update():
	#STUNNED TO IDLE#
	if not enemy.finished and animation_finished:
		base.current_state = null
		base.queue_state = base.get_state('Idle')
		exit()
	
#destructor
func exit():
	enemy.anim_node.disconnect('animation_finished',self,'animation_ended')
	base = null
	enemy = null
	animation_finished = false
	
	emit_signal('exited')




