extends Control

"""
	Manages all the graphical user interface in the game.
"""

var level_score = 0
var total_score = 0

#constructor
func init(score):
	level_score = score

#show a spawning arrow mark
func spawning_arrow(at,duration):
	show_graphics(preload('res://sprites/ui/arrow.png'),at,duration)

func show_graphics(texture,position,duration=-1):
	var spr = Sprite.new()