extends Area2D

"""
	Manages power-ups initialization, data and life time 
"""

#store each powerup effect and offset
var data = {
	"1Live":{"effect":funcref(self,"add_life"),"args":1,"offset":Vector2(25,-25)},
	"Spray":{"effect":funcref(self,"add_spray"),"args":1,"offset":Vector2(25,-15)}
}

var type = null
var level = null

#initialize
func init(pos,level):
	self.global_position = pos
	self.level = level
	
	#randomize power-up
	var types = get_children()
	types.erase($LifeTimer)
	types.shuffle()
	type = get_node(types[0].name)
	type.show()
	type.disabled = false
	
	#apply offset
	self.global_position.x+= data[type.name]['offset'].x
	self.global_position.y+= data[type.name]['offset'].y
	

func add_life(amount):
	level.add_lives(amount,global_position)

func add_spray(amount):
	level.add_sprays(amount,global_position)

func on_body_entered(body):
	if body.name == 'Player':
		data[type.name]['effect'].call_func(data[type.name]['args'])
		
		call_deferred('free')

func on_lifetime_end():
	queue_free()

