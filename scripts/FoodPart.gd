extends RigidBody2D

"""
	Manage all the food's object in game.
"""

var step_points = 0
var last_base = null
var is_falling = false
var falling_base = null

const max_step_points = 99

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
func _process(delta):
	$TextureProgress.value = step_points
	
	#stop falling when it reaches a base
	if falling_base != null:
		if falling_base.global_position.distance_to(global_position) <=4:
			set_gravity_scale(0)
			set_linear_velocity(Vector2(0,0))
			falling_base = null
			
			#reset points
			

func connect_parts():
	for part in $Parts.get_children():
		if not part.is_connected('body_entered',self,'break_part'):
			part.connect('body_entered',self,'break_part',[part])
	step_points = 0

func break_part(body,part):
	if body.name == 'Player':
		step_points += 33
		part.disconnect('body_entered',self,'break_part')
	
	if step_points >= max_step_points:
		break_free()

#the food will start to fall
func break_free():
	set_gravity_scale(2)

#check if collided with other food parts
func body_collision(body):
	if body.is_in_group('FoodPart'):
		body.break_free()

#check if it collided with the base
func area_collision(area):
	if area.is_in_group('Base') and last_base != area:
		falling_base = area
		last_base = area
		connect_parts()










