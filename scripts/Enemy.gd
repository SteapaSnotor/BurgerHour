extends KinematicBody2D

"""
	Manages the enemy's AI and informations.
"""

signal wall_collision
signal died
signal fall
signal sprayed

onready var colliders = {$FSM/Spawning: [$HitDetection/BananaSearching,$HitDetection/BrocSearching],
$FSM/Idle: [$HitDetection/BananaSearching,$HitDetection/BrocSearching],
$FSM/Searching: [$HitDetection/BananaSearching,$HitDetection/BrocSearching],
$FSM/Climbing: [$HitDetection/BananaClimbing,$HitDetection/BrocSearching],
$FSM/Falling: [$HitDetection/BananaSearching,$HitDetection/BrocSearching],
$FSM/Attacking: [$HitDetection/BananaSearching,$HitDetection/BrocSearching]}

var current_collider = null

onready var FSM = $FSM
onready var anim_node = $AnimatedSprite

#stats
var speed = 70 #70
var facing_dir = Vector2(0,0)

var id = 1 #will define things like animations and stats
var on_ladder = false
var on_edge = false
var on_food = false
var current_food = null
var ladder_tiles = null
var floor_tiles = null
var _current_collisions = []
var is_seeing_player = false
var player = null
var finished = false setget set_level_finished #when the player wins 
#var initial_spawn = Vector2(0,0)

const base_z_index = 5

#initialize
func _ready():
	FSM.init()
	#init colliders
	current_collider = colliders[FSM.get_current_state()][id]
	update_colliders()
	FSM.connect('changed_state',self,'update_colliders')
	
	#initial_spawn = global_position

func _process(delta):
	update_animations()
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
		if not body.get_parent().on_final_base:
			emit_signal("died")
			call_deferred('free')
	elif body.name == 'SmokeDetection':
		#TODO: delegate this to a new state
		emit_signal("sprayed")
		call_deferred('free')
	elif body.name == 'PlayerHit':
		body.get_parent().hit = true
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

func on_player_sight(area):
	if area.name == 'PlayerHit':
		if area.get_parent().FSM.get_current_state().name != 'Climbing':
			is_seeing_player = true
			player = area.get_parent()
		

func out_player_sight(area):
	if area.name == 'PlayerHit':
		is_seeing_player = false
		
func set_level_finished(value):
	finished = value
	
	if finished:
		#don't move when the level is over
		FSM.force_state('Idle')

func update_animations():
	$AnimatedSprite.set_flip_h(facing_dir.x == 1)
	#$HitDetection.set_scale(Vector2(1 - (int(facing_dir.x == 1)+ int(facing_dir.x == 1)),1))
	$AnimatedSprite.play(str(id)+':'+FSM.get_current_state().name)
	
func update_colliders():
	current_collider.call_deferred('set_disabled',true)
	current_collider = colliders[FSM.get_current_state()][id]
	current_collider.call_deferred('set_disabled',false)








