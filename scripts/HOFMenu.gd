extends Node2D

"""
	Handles the Hall of fame Menu screen. It Just show a score 
	from newgrounds or from the computer.
"""

signal exited

var table = {} setget set_table

const max_chars = 61
const max_name_chars = 10

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("exited")
		queue_free()
		
func set_table(value):
	table = value
	if table['names'].size() == 0:return
	
	var rank = 1
	for score in range(table['names'].size()):
		var user = table['names'][score].substr(0,max_name_chars)
		var num = format_num(int(table['points'][score]),7)
		var points = '.'
		
		for pt in range(max_chars - (len(user)+7) ):
			points = points + '.'
		
		var final_str = str(rank) + ' - ' + user.to_upper() + points + num
		
		$Values.get_child(score).text = final_str
		
		rank += 1 
		

func format_num(num,pads_num):
	var pads = ''
	for ch in range(pads_num - len(str(num))):
		pads = pads + '0'
		
	return pads + str(num)








