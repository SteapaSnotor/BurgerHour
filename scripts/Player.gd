extends KinematicBody2D

"""
	Manage the player character's information.
"""

#all player's animation according to state and facing direction
var animations_data = {
	'Idle':{Vector2(0,0):{'anim':'Idle-Down','flip':false},
Vector2(1,0):{'anim':'Idle-Sides','flip':true},
Vector2(-1,0):{'anim':'Idle-Sides','flip':false}},
	
	'Walking':{Vector2(0,0):{'anim':'Walking','flip':false},
Vector2(1,0):{'anim':'Walking','flip':true},
Vector2(-1,0):{'anim':'Walking','flip':false}},

	'Climbing':{Vector2(0,0):{'anim':'Climbing','flip':false,'stop':true},
Vector2(0,1):{'anim':'Climbing','flip':false,'stop':false},
Vector2(0,-1):{'anim':'Climbing','flip':false,'stop':false}},

	'Dead':{Vector2(0,0):{'anim':'Idle-Down','flip':false},
Vector2(1,0):{'anim':'Idle-Sides','flip':true},
Vector2(-1,0):{'anim':'Idle-Sides','flip':false},
Vector2(0,1):{'anim':'Idle-Sides','flip':false},
Vector2(0,-1):{'anim':'Idle-Sides','flip':false}},

	'Spraying':{Vector2(0,0):{'anim':'Spraying','flip':false},
Vector2(1,0):{'anim':'Spraying','flip':true},
Vector2(-1,0):{'anim':'Spraying','flip':false}},

	'TotallyDead':{Vector2(0,0):{'anim':'Idle-Down','flip':false},
Vector2(1,0):{'anim':'Idle-Sides','flip':true},
Vector2(-1,0):{'anim':'Idle-Sides','flip':false},
Vector2(0,1):{'anim':'Idle-Sides','flip':false},
Vector2(0,-1):{'anim':'Idle-Sides','flip':false}}

}

#stats
var speed = 100
var hit = false setget set_hit

#nodes
onready var FSM = $FSM
onready var debug_label = $_CurrentState
onready var anim_node = $Animations

var facing_dir = Vector2(0,0)
var ladder_pos = Vector2(0,0)
var on_ladder = false
var on_edge = false
var floor_tiles = []
var ladder_tiles = []
var has_sprays = true
var level_finished = false setget set_level_finished

const base_z_index = 5

#initialize
func _ready():
	#init FSM.
	FSM.init()
	
func _process(delta):
	#debug state
	debug_label.text = FSM.get_current_state().name
	#print($Animations.global_position.y)
	update_animations()
	
	if Input.is_action_just_pressed("ui_end"):
		get_tree().paused = !get_tree().is_paused()
	
#return the state of keys used to walk
func get_walk_keys():
	return [Input.is_action_pressed('ui_left'),
Input.is_action_pressed('ui_right')]

#return the state of keys used to climb
func get_climb_keys():
	return [Input.is_action_pressed('ui_up'),
Input.is_action_pressed('ui_down')]

#return the state of keys used to spray
func get_spray_keys():
	return [Input.is_action_pressed("spray"),
Input.is_action_pressed("ui_accept")]

#when the player is hit
func set_hit(value):
	hit = value
	
	if hit and FSM.get_current_state().name != 'Dead' and FSM.get_current_state().name != 'TotallyDead':
		FSM.force_state('Dead')

#when the player wins the level
func set_level_finished(value):
	level_finished = value
	
	if level_finished: FSM.force_state('Idle')

func update_animations():
	var state = FSM.get_current_state().name
	
	if animations_data[state][facing_dir].keys().find('stop') != -1:
		if animations_data[state][facing_dir]['stop']:
			if anim_node.get_animation() == animations_data[state][facing_dir]['anim']:
				anim_node.stop()
				return
	
	anim_node.play(animations_data[state][facing_dir]['anim'])
	anim_node.set_flip_h(animations_data[state][facing_dir]['flip'])

#move the player in a given direction
func move(dir):
	move_and_slide(dir*speed)
	facing_dir = dir

#spawn the player's pepper spray smoke
func spawn_smoke(dir):
	var smoke = preload('res://scenes/PepperSmoke.tscn').instance()
	var smoke_speed = 700
	get_parent().add_child(smoke)
	smoke.global_position = Vector2(global_position.x+(dir.x*34),global_position.y)
	smoke.init(dir,smoke_speed)












