extends Node

"""
	Manages the game
"""

var score = {
	0:0,
	1:0
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
	_world.connect('new_score',self,'on_new_score')
	_world.connect('level_reloaded',self,'update_gui')
	_world.connect('level_reloaded',self,'update_world')
	_world.load_level(selected_level)
	_world.current_level.connect('finished',self,'on_level_finished')
	_world.current_level.connect('player_died',self,'on_player_lose')
	_world.current_level.connect('player_sprayed',self,'on_new_spray_count')
	
func init_gui():
	_gui.init(_world.level_new_score,_world.current_level.sprays,
	_world.lives)
	
	#gui signals
	_gui.connect('restart_btn',_world,'restart_level')
	_gui.connect('next_btn',self,'on_next_level')
	_gui.connect('restart_over_btn',self,'on_restart_game')

func update_gui():
	_gui.init(_world.level_new_score,_world.current_level.sprays,
_world.lives)

func update_world():
	_world.current_level.connect('finished',self,'on_level_finished')
	_world.current_level.connect('player_died',self,'on_player_lose')
	_world.current_level.connect('player_sprayed',self,'on_new_spray_count')

#when there's a new enemy on the game
func on_new_enemy():
	_gui.spawning_arrow(_world.new_enemy_data['at'],_world.new_enemy_data['time'])

func on_level_finished():
	#TODO: player animation
	#TODO: scene showing the player score for this level and his total score
	_gui.show_screen('WonLevel')
	score[selected_level] = _world.level_new_score

func on_new_score():
	_gui.set_level_score(_world.level_new_score)
	_gui.flying_label(_world.current_level.new_points_position,str(_world.level_new_score - _world.level_old_score))

func on_new_spray_count():
	_gui.set_player_sprays(_world.current_level.sprays)

func on_player_lose():
	_world.lives -= 1
	if _world.lives >= 0:
		_gui.show_screen('LostLevel')
	else:
		_gui.show_screen('GameOver')

func on_next_level():
	selected_level += 1

	_world.exit_level()
	if not _world.load_level(selected_level):
		print('No more levels! The game has been beaten!')
		return
	update_gui()
	update_world()

#restart all the level
func on_restart_game():
	selected_level = 0
	_world.lives = 3
	_world.exit_level()
	if not _world.load_level(selected_level):
		print('Couldnt restart the game')
		return
	update_gui()
	update_world()
	#TODO: clear score

	















