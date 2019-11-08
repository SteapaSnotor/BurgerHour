extends CanvasLayer

"""
	Manages all the graphical user interface in the game.
"""

signal restart_btn
signal next_btn

onready var timer = $GUITimer

var level_score = 0
var total_score = 0

#constructor
func init(score):
	level_score = score

#show a spawning arrow mark
func spawning_arrow(at,duration):
	var new_at = Vector2(0,0)
	var flip = true
	if at.x < 0:
		new_at = Vector2(at.x+149,at.y)
		flip = false
	else: new_at = Vector2(at.x-75,at.y)
	
	show_graphics(preload('res://sprites/ui/arrow.png'),new_at,duration,flip)

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

func hide_graphics(graphic,_signal = null):
	graphic.queue_free()
	
	if _signal != null: _signal.queue_free()

func show_screen(scr):
	var screen = $Screens.get_node(scr)
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




