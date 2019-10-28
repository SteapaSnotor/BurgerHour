extends Node

"""
	Finite state machine.
"""

onready var current_state = null

var queue_state = null setget set_queue_state
var last_state = null

#initialize states
func init():
	var states = get_children()
	
	for state in states:
		if not state.has_method('initialize'): continue
		state.connect('exited',self,'set_state')
	
	queue_state = get_child(0)
	last_state = get_child(0)
	set_state()
	
#go to a new state
func set_state():
	current_state = queue_state
	current_state.initialize(self,get_parent())
	set_process(true)
	set_physics_process(true)

func set_queue_state(value):
	last_state = queue_state
	queue_state = value
	
func get_current_state():
	return current_state

#get state by name
func get_state(_name):
	for state in get_children(): if state.name == _name: return state

func _physics_process(delta):
	if current_state == null: return set_physics_process(false)
#	if current_state != null: print(last_state.name)
	current_state.physics_update(delta)
	current_state.transitions_update()
	
func _input(event):
	if current_state == null: return set_process_input(false)
	
	current_state.input_update(event)






