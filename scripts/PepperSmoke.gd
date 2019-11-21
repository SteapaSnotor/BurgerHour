extends RigidBody2D

"""
	The pepper smoke released by the player. It's freed when hitting
	an enemy.
"""

var dir = Vector2(0,0)

func init(dir,speed):
	self.dir = dir
	set_linear_velocity(dir * speed)
	$Smoke.set_emitting(true)

func _physics_process(delta):
	if get_linear_velocity().y < 60:
		set_linear_velocity(Vector2(get_linear_velocity().x-3,get_linear_velocity().y))
	else:
		queue_free()
	
	$Smoke.set_gravity(Vector2(1000*(dir.x*-1),get_linear_velocity().y*-10))