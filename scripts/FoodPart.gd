extends RigidBody2D

"""
	Manage all the food's object in game.
"""

signal on_final_base

var id = 0
var step_points = 0
var last_base = null
var is_falling = false
var falling_base = null
var on_final_base = false setget set_on_final_base
var current_state = [0,0,0,0]

const max_step_points = 100

#initialize
func init():
	#add base to the main scene
	var _base = $Base.duplicate()
	get_parent().add_child(_base)
	_base.global_position = global_position
	last_base = _base
	$Base.queue_free()
	
	#signals for the breakable parts
	connect_parts()

#TODO: update animations
func _physics_process(delta):
	$TextureProgress.value = step_points
	#update anims according to the food state
	var anim = str(current_state[0]) + str(current_state[1]) + str(current_state[2]) + str(current_state[3])
	$States.play(anim)
	
	#print(is_falling)
	if on_final_base:
		#prevent from falling when on the final base
		set_gravity_scale(0)
		set_linear_velocity(Vector2(0,0))
		is_falling = false
		return
	
	#stop falling when it reaches a base
	if falling_base != null:
		if falling_base.global_position.distance_to(global_position) <=4:
			set_gravity_scale(0)
			set_linear_velocity(Vector2(0,0))
			falling_base = null
			is_falling = false
			#reset points
			
func connect_parts():
	for part in $Parts.get_children():
		if not part.is_connected('body_entered',self,'break_part'):
			part.connect('body_entered',self,'break_part',[part])
	step_points = 0
	current_state = [0,0,0,0]
	
func break_part(body,part):
	if on_final_base: return
	if body.name == 'Player':
		step_points += 25
		part.disconnect('body_entered',self,'break_part')
		current_state[$Parts.get_children().find(part)] = 1
	
	if step_points >= max_step_points:
		break_free()

#the food will start to fall
func break_free():
	if not on_final_base:
		set_gravity_scale(2)
		is_falling = true

#check if collided with other food parts
func body_collision(body):
	if body.is_in_group('Enemy') or body.name == 'Player': return
	#food order of drawing
	if body.global_position.y > global_position.y:
		set_z_index(body.get_z_index()+1)
		#print('changed food part z-index')
	
	if body.is_in_group('FoodPart'):
		if not body.on_final_base:
			body.break_free()
		else:
			if not on_final_base: set_on_final_base(true)
			set_gravity_scale(0)
			set_linear_velocity(Vector2(0,0))
			is_falling = false

#check if it collided with the base
func area_collision(area):
	if area.is_in_group('Base') and last_base != area:
		falling_base = area
		last_base = area
		connect_parts()
	elif area.is_in_group('FinalBase'):
		set_on_final_base(true)
		set_gravity_scale(0)
		set_linear_velocity(Vector2(0,0))
		is_falling = false

func set_on_final_base(value):
	if not on_final_base: emit_signal("on_final_base")
	on_final_base = value
	
	if on_final_base: 
		set_z_index(get_z_index()+7)
	current_state = [0,0,0,0]





