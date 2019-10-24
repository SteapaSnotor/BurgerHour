extends KinematicBody2D

"""
	Manages the enemy's AI and informations.
"""

onready var FSM = $FSM

#stats
var speed = 70
var facing_dir = Vector2(0,0)
var on_ladder = false

#initialize
func _ready():
	FSM.init()

func _process(delta):
	$_CurrentState.text = FSM.get_current_state().name

func move(dir):
	move_and_slide(dir*speed)
	facing_dir = dir