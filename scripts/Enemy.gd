extends KinematicBody2D

"""
	Manages the enemy's AI and informations.
"""

signal wall_collision

onready var FSM = $FSM

#stats
var speed = 70
var facing_dir = Vector2(0,0)

var on_ladder = false
var on_edge = false
var on_food = false
var current_food = null
var ladder_tiles = null
var floor_tiles = null
var _current_collisions = []

const base_z_index = 5

#initialize
func _ready():
	FSM.init()

func _process(delta):
	#debug only
	$_CurrentState.text = FSM.get_current_state().name

func move(dir,spd = speed):
	move_and_slide(dir*spd)
	facing_dir = dir

#detect collisions with walls, the player and some others
func on_hit_detection(body):
	if body.name == 'LevelSignals':
		if _current_collisions.find(body) == -1: _current_collisions.append(body)
		emit_signal("wall_collision")
	elif body.name == 'BaseDetection':
		#TODO: maybe delegate this to a "dead" state?
		call_deferred('free')
	else: pass#print(body.name)

func on_food_detection(area):
	if area.name == 'BaseDetection':
		on_food = true
		current_food = area.get_parent()

func on_exit_food_detection(area):
	if area.name == 'BaseDetection' and FSM.get_current_state().name != 'Falling':
		on_food = false
		current_food = null

func exit_hit_detection(body):
	if body.name == 'LevelSignals':
		if _current_collisions.find(body) != -1: _current_collisions.erase(body)

#return the number of collisions
func get_collision_count():
	return _current_collisions.size()
















