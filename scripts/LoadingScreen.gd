extends Node2D

"""
	Handles the loading screen.
"""

signal loaded

var loader = null
var _level = null

#initialize
func init(level):
	$FakeDelay.start()
	yield($FakeDelay,'timeout')
	loader = ResourceLoader
	loader = loader.load_interactive(level)
	set_process(true)
	
#load the level here
func _process(delta):
	if loader == null: 
		set_process(false)
		return
	
	$GUI/LoadingBar.set_max(loader.get_stage_count()-1)
	$GUI/LoadingBar.set_value(loader.get_stage())
	
	var error = loader.poll()
	if error == ERR_FILE_EOF:
		_level = loader.get_resource().instance()
		emit_signal("loaded")
		loader = null
		
func get_level():
	return _level





