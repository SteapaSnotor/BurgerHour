extends Node

"""
	Enemy Spawning state
"""

signal entered
signal exited

var base = null
var enemy = null
var dir = Vector2(0,0)
var spawn_tile = Vector2(0,0)

#constructor
func initialize(base,enemy):
	self.base = base
	self.enemy = enemy
	#This will only work if the level is build from the top-left to down-right
	var floor_width = self.enemy.floor_tiles.get_cell_size().x
	if enemy.global_position.x <=0:
		dir = Vector2(1,0)
		spawn_tile = Vector2(enemy.global_position.x+floor_width*3,enemy.global_position.y)
	else: 
		dir = Vector2(-1,0)
		spawn_tile = Vector2(enemy.global_position.x-floor_width*3,enemy.global_position.y)
	
	emit_signal('entered')

func physics_update(delta):
	if enemy == null: return
	
	enemy.move(dir)

func input_update(event):
	pass

func transitions_update():
	if enemy.global_position.distance_to(spawn_tile) < 10:
		base.current_state = null
		base.queue_state = base.get_state('Searching')
		exit()
	

#destructor
func exit():
	base = null
	enemy = null
	dir = Vector2(0,0)
	spawn_tile = Vector2(0,0)
	
	emit_signal('exited')


