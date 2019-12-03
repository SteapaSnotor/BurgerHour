extends CanvasLayer

"""
	Manages all the graphical user interface in the game.
"""

signal restart_btn
signal next_btn
signal restart_over_btn

onready var timer = $GUITimer

var level_score = 0 setget set_level_score
var total_score = 0 setget set_total_score
var player_sprays = 3 setget set_player_sprays
var player_lives = 0 setget set_player_lives

#constructor
func init(score,sprays,lives,t_score):
	set_level_score(score+t_score)
	set_player_sprays(sprays)
	set_player_lives(lives)
	set_total_score(t_score)

#show a spawning arrow mark
func spawning_arrow(at,duration):
	var new_at = Vector2(0,0)
	var flip = true
	if at.x < 0:
		new_at = Vector2(at.x+149,at.y)
		flip = false
	else: new_at = Vector2(at.x-75,at.y)
	
	show_graphics(preload('res://sprites/ui/arrow.png'),new_at,duration,flip)

#show a label animation
func flying_label(pos,txt):
	var new_label = $FlyingLabel/LabelAnims.duplicate()
	$FlyingLabel.add_child(new_label)
	new_label.get_child(0).get_child(0).rect_global_position = pos
	new_label.get_child(0).get_child(0).text = txt
	new_label.get_child(0).show()
	
	new_label.connect("animation_finished",self,'finished_label_animation',[new_label])
	new_label.play("Vertical")

func show_graphics(texture,position,duration=-1,flip=false):
	var spr = Sprite.new()
	spr.set_flip_h(flip)
	spr.texture = texture
	add_child(spr)
	spr.global_position = position
	
	if duration == -1: return
	
	var graphics_timer = timer.duplicate()
	add_child(graphics_timer)
	graphics_timer.stop()
	graphics_timer.wait_time = duration
	graphics_timer.connect('timeout',self,'hide_graphics',[spr,graphics_timer])
	graphics_timer.start()

#the score only on this level, is reseted by the world everytime the game
#restarts
func set_level_score(value):
	level_score = value
	
#	$LevelInfo/SCORE.text = str(level_score)

#this is the total score including all levels
func set_total_score(value):
	total_score = value
	
	var pads = ''
	for ch in range(7 - len(str(total_score))):
		pads = pads + '0'

	$LevelInfo/SCORE.text = pads + str(total_score)
	

#hide/show spray slots
func set_player_sprays(value):
	player_sprays = value
	
	var slots = [$LevelInfo/Sprays/Slot1,$LevelInfo/Sprays/Slot2,
	$LevelInfo/Sprays/Slot3]
	
	for sprays in range(slots.size()):
		slots[sprays].set_visible(sprays+1 <= player_sprays)
		
	
	#old debug label
	#$LevelInfo/SPRAYS.text = 'SPRAYS: ' + str(player_sprays)

func set_player_lives(value):
	player_lives = value
	
	var slots = [$LevelInfo/Lives/Slot1,$LevelInfo/Lives/Slot2,
	$LevelInfo/Lives/Slot3]
	
	for lives in range(slots.size()):
		slots[lives].set_visible(lives+1 <= player_lives)
	
	#old debug label
	#$LevelInfo/LIVES.text = 'LIVES : ' + str(player_lives)

func hide_graphics(graphic,_signal = null):
	graphic.queue_free()
	
	if _signal != null: _signal.queue_free()

func show_screen(scr):
	var screen = $Screens.get_node(scr)
	if screen.is_visible():return
	screen.show()
	for element in screen.get_children():
		if element is Button or element is TextureButton: #screen buttons
			element.connect('pressed',self,'on_btn_pressed',[element])
		#TODO: screen animations
	
func hide_screen(scr):
	var screen = $Screens.get_node(scr)
	screen.hide()
	for element in screen.get_children():
		if element is Button or element is TextureButton: #screen buttons
			element.disconnect('pressed',self,'on_btn_pressed')
	

func on_btn_pressed(btn):
	match btn.name:
		'Restart':
			emit_signal('restart_btn')
			hide_screen('WonLevel')
		'LRestart':
			emit_signal('restart_btn')
			hide_screen('LostLevel')
		'Next':
			emit_signal('next_btn')
			hide_screen('WonLevel')
		'GRestart':
			emit_signal('restart_over_btn')
			hide_screen('GameOver')

func finished_label_animation(animation,label):
	label.queue_free()


