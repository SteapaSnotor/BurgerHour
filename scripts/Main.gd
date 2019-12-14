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
var _audio = null
var selected_level = 0

#initialize all the game here
func _ready():
	_world = $World
	_gui = $GUI
	_audio = $Audio
	init_audio()
	init_menu()

	#init_world()
	#init_gui()
	
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
	_world.current_level.connect('player_sprayed',self,'on_new_spray_count',[false])
	_world.current_level.connect('new_sprays',self,'on_new_spray_count',[true])
	_world.current_level.connect('new_lives',self,'on_lives_powerup')
	
func init_gui():
	_gui.init(_world.level_new_score,_world.current_level.sprays,
	_world.lives,get_total_score())
	
	#gui signals
	_gui.connect('restart_btn',_world,'restart_level')
	_gui.connect('next_btn',self,'on_next_level')
	_gui.connect('restart_over_btn',self,'on_restart_game')
	_gui.connect('pause_btn',self,'on_pause_game')

func init_menu():
	var _menu = preload('res://scenes/Menu.tscn').instance()
	_menu.connect('play',self,'on_start_game')
	add_child(_menu)
	
	_audio.play_music('Menu')

func init_audio():
	_audio.init()

func update_gui():
	_gui.init(_world.level_new_score,_world.current_level.sprays,
_world.lives,get_total_score())

func update_world():
	_world.current_level.connect('finished',self,'on_level_finished')
	_world.current_level.connect('player_died',self,'on_player_lose')
	_world.current_level.connect('player_sprayed',self,'on_new_spray_count',[false])
	_world.current_level.connect('new_sprays',self,'on_new_spray_count',[true])
	_world.current_level.connect('new_lives',self,'on_lives_powerup')

func clear_score():
	for id in score:
		score[id] = 0

#returns the sum of all scores in all levels
func get_total_score():
	var final_score = 0
	for points in score:
		final_score += score[points]
	return final_score

#when there's a new enemy on the game
func on_new_enemy():
	_gui.spawning_arrow(_world.new_enemy_data['at'],_world.new_enemy_data['time'])

func on_level_finished():
	_world.current_level.player.level_finished = true
	#init score screen
	var screen = preload('res://scenes/ScoreScreen.tscn').instance()
	_world.add_child(screen)
	screen.init(_world.level_new_score, get_total_score(),
	_world.live_points, _world.bonus_points- (_world.live_points+_world.spray_points),
	_world.spray_points)
	screen.connect('player_continue',self,'on_score_screen_animation')
	
	_gui.show_screen('WonLevel')
	_gui.hide_ui('Screens')
	score[selected_level] = _world.level_new_score
	_audio.stop_music('Jazz1',true)
	
	"""
	print('bonus ' + str(_world.bonus_points- (_world.live_points+_world.spray_points)))
	print('lives ' + str(_world.live_points))
	print('sprays ' + str(_world.spray_points))
	print('total: ' + str(_world.level_new_score))
	"""

#when the player pressed enter on the score animation and is ready to 
#to continue.
func on_score_screen_animation():
	_gui.show_ui()
	var anim = _gui.get_node('Screens/WonLevel/ScreenAnim')
	var camera = _gui.get_node('Screens/WonLevel/CamEffect')
	camera.global_position.y = 434
	anim.stop(true)
	on_next_level()

func on_new_score():
	_gui.set_level_score(_world.level_new_score)
	_gui.set_total_score(get_total_score()+_world.level_new_score)
	_gui.flying_label(_world.current_level.new_points_position,str(_world.level_new_score - _world.level_old_score))
	_world.bonus_points += _world.level_new_score - _world.level_old_score 
	
func on_new_spray_count(powerup=false):
	if not powerup: _world.sprays -= 1
	else:
		if _world.sprays >= _world.max_sprays:
			_world.current_level.add_points(100,_world.current_level.new_sprays_position)
			_world.spray_points += 100
			return
		elif (_world.sprays + _world.current_level.new_sprays) > _world.max_sprays:
			_world.sprays = _world.max_sprays
		else:
			_world.sprays+= _world.current_level.new_sprays
		
	_world.current_level.sprays = _world.sprays
	_gui.set_player_sprays(_world.current_level.sprays)

#when the player got a live powerup
func on_lives_powerup():
	if _world.lives >= _world.max_lives:
		#can't add new lives, try to add new score points instead
		_world.current_level.add_points(100,_world.current_level.new_lives_position)
		_world.live_points += 100
		return
	elif (_world.lives + _world.current_level.new_lives) > _world.max_lives:
		#got more than he can chew, fill the maximum amount of lives and add points
		_world.lives = _world.max_lives
		_world.current_level.add_points(50,_world.current_level.new_lives_position)
		_world.live_points += 50
	else:
		_world.lives += _world.current_level.new_lives
		
	update_gui()
	
func on_player_lose():
	_world.lives -= 1
	if _world.lives >= 0:
		_gui.show_screen('LostLevel')
	else:
		_gui.show_screen('GameOver')
		clear_score()

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
	_world.sprays = 3
	_world.exit_level()
	if not _world.load_level(selected_level):
		print('Couldnt restart the game')
		return
	update_gui()
	update_world()
	#TODO: clear score

#when the player starts choice to start the game
func on_start_game():
	init_world()
	init_gui()
	get_node("Menu").queue_free()
	
	#TODO: get the music name from the level instead
	#TODO: start the music only when the level is loaded
	_audio.play_music('Jazz1',true)

#when the player hits the pause key/button
func on_pause_game():
	if _world.current_level.finished: return
	
	var options_scr = preload('res://scenes/OptionsMenu.tscn').instance()
	_gui.hide_ui()
	options_scr.connect("exited",_world,'resume_game')
	options_scr.connect("exited",_gui,'show_ui')
	add_child(options_scr)
	_world.pause_game()













