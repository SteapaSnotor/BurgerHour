extends Node

"""
	Manages the game
"""

var score = {
	0:0
}

var _world = null
var _gui = null
var selected_level = 0

#initialize all the game here
func _ready():
	_world = $World
	_gui = $GUI
	
	#TODO: don't init the world at the start of the game
	init_world()
	init_gui()
	
	#TODO: loads the main menu instead
	randomize()
	
func init_world():
	_world.connect('new_enemy',self,'on_new_enemy')
	_world.load_level(selected_level)
	_world.current_level.connect('finished',self,'on_level_finished')
	_world.current_level.connect('player_died',self,'on_player_lose')
	
func init_gui():
	_gui.init(score[selected_level])
	
	#gui signals
	_gui.connect('restart_btn',_world,'restart_level')
	_gui.connect('next_btn',self,'on_next_level')

#when there's a new enemy on the game
func on_new_enemy():
	_gui.spawning_arrow(_world.new_enemy_data['at'],_world.new_enemy_data['time'])

func on_level_finished():
	#TODO: player animation
	#TODO: scene showing the player score for this level and his total score
	_gui.show_screen('WonLevel')

func on_player_lose():
	_gui.show_screen('LostLevel')

func on_next_level():
	selected_level += 1
	
	_world.exit_level()
	if not _world.load_level(selected_level):
		print('No more levels! The game has been beaten!')

