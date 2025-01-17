extends Node2D

"""
	Handles the main menu screen.
"""

signal play
signal options
signal hof
signal about
signal entered
signal clog

onready var buttons = [$PlayBtn,$OptionsBtn,$HOFBtn,$AboutBtn]

var selelected_btn = 0
var normal_selected = null
var is_locked = false

#TODO: maybe the main node shoud call this instead
func _ready():
	init()
	
		

#initialize menu
func init():
	show()
	selelected_btn = 0
	normal_selected = buttons[selelected_btn].texture_normal

	for button in buttons:
		button.connect('pressed',self,'btn_pressed',[button])
		button.connect('mouse_entered',self,'btn_hovered',[button])
	
	#buttons without hovering effect
	$Version/ChangelogBtn.connect('pressed',self,'btn_pressed',[$Version/ChangelogBtn])
	
	btn_hovered(buttons[selelected_btn])
	
	$Version.text = 'VERSION ' + str(Settings.version) 
	
	emit_signal("entered")
	
func _input(event):
	var down = int(Input.is_action_just_pressed("ui_down"))
	var up = int(Input.is_action_just_pressed("ui_up"))
	var ok = int(Input.is_action_just_pressed("spray"))
	var new_btn = selelected_btn
	
	if is_locked: return
	
	if down-up != 0:#button selection
		new_btn += (down-up)
		
		if new_btn == buttons.size():
			new_btn = 0
		elif new_btn < 0:
			new_btn = buttons.size()-1
		
		btn_hovered(buttons[new_btn])
	elif ok: #button pressed
		btn_pressed(buttons[selelected_btn])

	
func btn_pressed(btn):
	match btn.name:
		'PlayBtn':
			set_process_input(false)
			emit_signal("play")
		'OptionsBtn':
			var _options = preload('res://scenes/OptionsMenu.tscn').instance()
			add_child(_options)
			_options.connect('exited',self,'unlock_btns')
			lock_btns()
			emit_signal("options")
		'AboutBtn':
			var _credits = preload('res://scenes/AboutMenu.tscn').instance()
			_credits.connect('exited',self,'unlock_btns')
			add_child(_credits)
			lock_btns()
			emit_signal("about")
			print('hahahah')
		'HOFBtn':
			var _hall = preload('res://scenes/HOFMenu.tscn').instance()
			_hall.connect('exited',self,'unlock_btns')
			add_child(_hall)
			lock_btns()
			emit_signal("hof")
		'ChangelogBtn':
			var _log = preload('res://scenes/Changelog.tscn').instance()
			_log.connect('exited',self,'unlock_btns')
			add_child(_log)
			lock_btns()
			emit_signal("clog")

func btn_hovered(btn):
	buttons[selelected_btn].texture_normal = normal_selected
	selelected_btn = buttons.find(btn)
	normal_selected = btn.texture_normal
	btn.texture_normal = btn.texture_hover
	
	$BurgerSelection.global_position.y = btn.rect_global_position.y+75
	
func lock_btns():
	is_locked = true
	for btn in buttons:
		btn.disabled = true
	
func unlock_btns():
	is_locked = false
	for btn in buttons:
		btn.disabled = false
	

func hide_elements(elements=[]):
	for element in elements:
		get_node(element).hide()







