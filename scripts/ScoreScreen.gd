extends Node2D

"""
	Handles the score screen scene. It shows breakdown of the points
	the playe has earned on the level in a basic animation.
"""

signal animation_finished
signal player_continue
signal finished

var new_score = 0
var old_score = 0
var old_temp = 0
var lives_points = 0
var bonus_points = 0
var spray_points = 0
var started_animation = false

#initialize
func init(new_score,old_score,lives_points,bonus_points,spray_points):
	self.new_score = new_score
	self.old_score = old_score
	self.old_temp = old_score
	self.lives_points = lives_points
	self.bonus_points = bonus_points
	self.spray_points = spray_points
	
#skip animation
func _input(event):
	if Input.is_action_just_pressed("spray"):
		if old_score != new_score + old_temp:
			lives_points = 0
			spray_points = 0
			bonus_points = 0
			old_score = new_score + old_temp
		else:
			if not $FadingAnim.is_playing():
				$FadingAnim.connect("animation_finished",self,"exit")
				$FadingAnim.play("Fading")
				set_process_input(false)

func start():
	$Lives.show()
	$Sprays.show()
	$Bonus.show()
	$Total.show()
	
	update_labels()
	started_animation = true
	
func update_total():
	if not started_animation: return
	
	if lives_points > 0:
		lives_points -= 1
		old_score += 1 
	elif spray_points > 0:
		spray_points -= 1
		old_score +=1
	elif bonus_points > 0:
		bonus_points -= 1
		old_score += 1 
	else:
		$ContinueMessage.show()
		started_animation = false
		emit_signal("animation_finished")
		
	update_labels()
	
func update_labels():
	$Lives.text = 'LIVES.......................................'+format_num(lives_points,7)
	$Sprays.text = 'SPRAYS.....................................'+format_num(spray_points,7)
	$Bonus.text = 'BONUS......................................'+format_num(bonus_points,7)
	$Total.text = 'TOTAL.............................'+format_num(old_score,10)

func format_num(num,pads_num):
	var pads = ''
	for ch in range(pads_num - len(str(num))):
		pads = pads + '0'
		
	return pads + str(num)

func exit(anim_name):
	emit_signal("player_continue")
	queue_free()





