extends Area2D

"""
	Tells an actor he can use a ladder when he's near one.
"""

func body_entered(body):
	#TODO: check for enemies too
	if body.name == 'Player':
		body.on_ladder = true
		body.ladder_pos = Vector2($Sprite.global_position.x+7,$Sprite.global_position.y)
	else: return
	
func body_exited(body):
	#TODO: check for enemies too
	if body.name == 'Player':
		body.on_ladder = false
		body.ladder_pos = Vector2(0,0)
	else: return