extends Node

"""
	Finite state machine.
"""

onready var current_state = null

var queue_state = null

#initialize states
func init():
	var states = {
		$Walking.name:$Walking,
		$Idle.name:$Idle,
		$Climbing.name:$Climbing
	}
	
	for state in states.values():
		state.connect('exited',self,'set_state')
	
	queue_state = $Idle
	set_state()
	
#go to a new state
func set_state():
	current_state = queue_state
	current_state.initialize(self,get_parent())
	set_process(true)
	set_physics_process(true)
	
func get_current_state():
	return current_state

#get state by name
func get_state(_name):
	for state in get_children(): if state.name == _name: return state

func _physics_process(delta):
	if current_state == null: return set_physics_process(false)
	
	current_state.physics_update(delta)
	current_state.transitions_update()
	
	
func _input(event):
	if current_state == null: return set_process_input(false)
	
	current_state.input_update(event)






