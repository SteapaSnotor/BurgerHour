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
var wall_buffer = false

#constructor
func initialize(base,enemy):
	self.base = base
	self.enemy = enemy
	if not self.base.last_state.name == 'Spawning' and not self.base.last_state.name == 'Attacking':
		self.dir = Vector2(1  -(int(rand_range(0,2)) * 2) ,0)
	else: self.dir = self.enemy.facing_dir 
	self.enemy.connect('wall_collision',self,'new_direction')
	
	emit_signal('entered')

func physics_update(delta):
	if enemy == null: return
	
	enemy.move(dir)
	"""
	if enemy.get_slide_count() > 0:
		dir.x*= -1
		
		if not base.last_state.name == 'idle': idle = true
	"""

#change the enemy direction on collisions
func new_direction():
	dir.x*= -1
	if not base.last_state.name == 'idle': idle = true

func input_update(event):
	pass

func transitions_update():
	#SEARCHING TO FALLING#
	if enemy.on_food and enemy.current_food != null:
		if enemy.current_food.is_falling:
			base.current_state = null
			base.queue_state = base.get_state('Falling')
			exit()
			return
		
	#SEARCHING TO CLIMBING#
	if enemy.on_ladder and base.last_state.name != 'Climbing':
		base.current_state = null
		base.queue_state = base.get_state('Climbing')
		exit()
	#SEARCHING TO IDLE#
	elif idle:
		base.current_state = null
		base.queue_state = base.get_state('Idle')
		exit()
	#SEARCHING TO ATTACKING#
	elif enemy.is_seeing_player:
		base.current_state = null
		base.queue_state = base.get_state('Attacking')
		exit()
	else: return

#destructor
func exit():
	enemy.disconnect('wall_collision',self,'new_direction')
	base = null
	enemy = null
	idle = false
	
	emit_signal('exited')




