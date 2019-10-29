extends Area2D

"""
	Tells the player when he's near the edge of a floor.
"""

func body_entered(body):
	#TODO: detect enemies too
	if body.name == 'Player':
		body.on_edge = true
	elif body.name == 'AILadderDetection':
		body.get_parent().on_edge = true
	else:
		return
	
func body_exited(body):
	#TODO: detect enemies too
	if body.name == 'Player':
		body.on_edge =false
	elif body.name == 'AILadderDetection':
		body.get_parent().on_edge = false
	else:
		return