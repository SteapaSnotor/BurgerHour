extends Node

"""
	Manages the game
"""

var score = {
	0:0,
	1:0,
	2:0,
	3:0,
	4:0,
	5:0,
	6:0,
	7:0,
	8:0
}

var _world = null
var _gui = null
var _audio = null
var _newgrounds = null
var _tree = null
var selected_level = 0

#initialize all the game here
func _ready():
	_world = $World
	_gui = $GUI
	_audio = $Audio
	_newgrounds = $Newgrounds
	_tree = get_tree()
	init_audio()
	init_menu()
	init_newgrounds()
	
	randomize()
	
func init_world():
	_world.connect('new_enemy',self,'on_new_enemy')
	_world.connect('new_score',self,'on_new_score')
	_world.connect('level_reloaded',self,'update_gui')
	_world.connect('level_reloaded',self,'update_world')
	_world.connect('level_loaded',self,'on_level_loaded')
	_world.connect('reloading_level',self,'on_reloading_level')
	_world.load_level(selected_level)
	yield(_world,'level_loaded')
	_world.current_level.connect('finished',self,'on_level_finished')
	_world.current_level.connect('player_died',self,'on_player_lose')
	_world.current_level.connect('player_sprayed',self,'on_new_spray_count',[false])
	_world.current_level.connect('new_sprays',self,'on_new_spray_count',[true])
	_world.current_level.connect('new_lives',self,'on_lives_powerup')
	_world.current_level.connect('player_hit',self,'on_player_hit')
	_world.current_level.connect('food_hit',self,'on_food_hit')
	_world.current_level.connect('player_broke_food',self,'on_player_broke_food')
	_world.current_level.connect('enemy_killed',self,'on_enemy_killed')
	
func init_gui():
	_gui.init(_world.level_new_score,_world.current_level.sprays,
	_world.lives,get_total_score())
	
	#gui signals
	_gui.connect('restart_btn',_world,'restart_level')
	_gui.connect('next_btn',self,'on_next_level')
	_gui.connect('restart_over_btn',self,'on_restart_game')
	_gui.connect('pause_btn',self,'on_pause_game')
	_gui.connect('quit_btn',self,'on_quit')

func init_menu():
	var _menu = preload('res://scenes/Menu.tscn').instance()
	_menu.connect('play',self,'on_start_game')
	_menu.connect('hof',self,'on_load_score')
	add_child(_menu)
	
	_audio.play_music('Menu')
	_world.connect('loading_level',_menu,'hide_elements',[['PlayBtn',
	'OptionsBtn','HOFBtn','AboutBtn','Title','Title2','Version','BurgerSelection']])
	
	return _menu


func init_audio():
	_audio.init()

func init_newgrounds():
	_newgrounds.init(30)

func update_gui():
	_gui.init(_world.level_new_score,_world.current_level.sprays,
_world.lives,get_total_score())

func update_world():
	_world.current_level.connect('finished',self,'on_level_finished')
	_world.current_level.connect('player_died',self,'on_player_lose')
	_world.current_level.connect('player_sprayed',self,'on_new_spray_count',[false])
	_world.current_level.connect('new_sprays',self,'on_new_spray_count',[true])
	_world.current_level.connect('new_lives',self,'on_lives_powerup')
	_world.current_level.connect('player_hit',self,'on_player_hit')
	_world.current_level.connect('food_hit',self,'on_food_hit')
	_world.current_level.connect('player_broke_food',self,'on_player_broke_food')
	_world.current_level.connect('enemy_killed',self,'on_enemy_killed')

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
	_newgrounds.add_score(get_total_score())
	_audio.stop_music(_world.current_level.music,true)
	
	"""
	print('bonus ' + str(_world.bonus_points- (_world.live_points+_world.spray_points)))
	print('lives ' + str(_world.live_points))
	print('sprays ' + str(_world.spray_points))
	print('total: ' + str(_world.level_new_score))
	"""


func on_level_loaded():
	_audio.play_music(_world.current_level.music,true)

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
		#_audio.play_music('YouLose',true)
	else:
		_gui.show_screen('GameOver')
		clear_score()

func on_player_hit():
	_audio.play_sound('Hit',true)
	_audio.stop_music()

func on_next_level():
	selected_level += 1

	_world.exit_level()
	if not _world.load_level(selected_level):
		print('No more levels! The game has been beaten!')
		on_beat_game()
		return
	yield(_world,'level_loaded')
	update_world()
	update_gui()

#restart all the levels
func on_restart_game():
	selected_level = 0
	_world.lives = 3
	_world.sprays = 3
	_world.exit_level()
	if not _world.load_level(selected_level):
		print('Couldnt restart the game')
		return
	yield(_world,'level_loaded')
	update_world()
	update_gui()
	#TODO: clear score

#when the player starts choice to start the game
func on_start_game():
	init_world()
	yield(_world,'level_loaded')
	init_gui()
	get_node("Menu").queue_free()
	
	#_audio.play_music('Jazz1',true)

#when the player hits the pause key/button
func on_pause_game():
	if _world.current_level.finished: return
	
	var options_scr = preload('res://scenes/OptionsMenu.tscn').instance()
	_gui.hide_ui()
	options_scr.connect("exited",_world,'resume_game')
	options_scr.connect("exited",_gui,'show_ui')
	add_child(options_scr)
	_world.pause_game()

#when the level is being reloaded
func on_reloading_level():
	_audio.stop_music()

#when a food part hits other food part
func on_food_hit():
	_audio.play_sound('Bounce',true)

func on_player_broke_food():
	_audio.play_sound('Fall')

func on_load_score():
	_newgrounds.get_score(get_node('Menu/HOFMenu'))

#check for some medals
func on_enemy_killed():
	if _world.current_level.last_enemy_killed == 0:
		if not _newgrounds.medals_data[58580]:
			_newgrounds.unlock_medal(58580)
	elif _world.current_level.last_enemy_killed == 1:
		if not _newgrounds.medals_data[58581]:
			_newgrounds.unlock_medal(58581)
	elif _world.current_level.last_enemy_killed == 2:
		if not _newgrounds.medals_data[58582]:
			_newgrounds.unlock_medal(58582)

#when the player beats the game
func on_beat_game():
	if not _newgrounds.medals_data[58579]:
		print('unlock this!')
		#_newgrounds.unlock_medal(58579)
	selected_level = 0
	_gui.hide_ui()
	_world.disconnect('new_enemy',self,'on_new_enemy')
	_world.disconnect('new_score',self,'on_new_score')
	_world.disconnect('level_reloaded',self,'update_gui')
	_world.disconnect('level_reloaded',self,'update_world')
	_world.disconnect('level_loaded',self,'on_level_loaded')
	_world.disconnect('reloading_level',self,'on_reloading_level')
	
	_gui.disconnect('restart_btn',_world,'restart_level')
	_gui.disconnect('next_btn',self,'on_next_level')
	_gui.disconnect('restart_over_btn',self,'on_restart_game')
	_gui.disconnect('pause_btn',self,'on_pause_game')
	_gui.disconnect('quit_btn',self,'on_quit')
	
	var menu = init_menu()

	menu.btn_pressed(menu.get_node('AboutBtn'))
	

#when the player hits the quit button
func on_quit():
	_world.exit_level()
	_world.lives = 3
	_world.sprays = 3
	selected_level = 0
	clear_score()
	_gui.hide_ui()
	_world.disconnect('new_enemy',self,'on_new_enemy')
	_world.disconnect('new_score',self,'on_new_score')
	_world.disconnect('level_reloaded',self,'update_gui')
	_world.disconnect('level_reloaded',self,'update_world')
	_world.disconnect('level_loaded',self,'on_level_loaded')
	_world.disconnect('reloading_level',self,'on_reloading_level')
	
	_gui.disconnect('restart_btn',_world,'restart_level')
	_gui.disconnect('next_btn',self,'on_next_level')
	_gui.disconnect('restart_over_btn',self,'on_restart_game')
	_gui.disconnect('pause_btn',self,'on_pause_game')
	_gui.disconnect('quit_btn',self,'on_quit')
	
	init_menu()





