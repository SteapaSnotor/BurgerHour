extends Node2D

"""
	Handles the main menu screen.
"""

signal play
signal options
signal hof
signal about

onready var buttons = [$PlayBtn,$OptionsBtn,$HOFBtn,$AboutBtn]

var selelected_btn = 0
var normal_selected = null

#debug
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
	
	btn_hovered(buttons[selelected_btn])

func _input(event):
	var down = int(Input.is_action_just_pressed("ui_down"))
	var up = int(Input.is_action_just_pressed("ui_up"))
	var ok = int(Input.is_action_just_pressed("spray"))
	var new_btn = selelected_btn
	
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

func btn_hovered(btn):
	buttons[selelected_btn].texture_normal = normal_selected
	selelected_btn = buttons.find(btn)
	normal_selected = btn.texture_normal
	btn.texture_normal = btn.texture_hover
	
	$BurgerSelection.global_position.y = btn.rect_global_position.y+75
	
func lock_btns():
	for btn in buttons:
		btn.disabled = true
	
func unlock_btns():
	for btn in buttons:
		btn.disabled = false
	

func hide_elements(elements=[]):
	for element in elements:
		get_node(element).hide()







