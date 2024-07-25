extends RigidBody2D

var player = null
var SPEED = 1
var force = 1
var distance 
var origin
@export_range(1,10, 1) var value = 1

var dir : Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var teta = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	teta  += 0.175
	if player and origin != player.global_position : 
		origin = player.global_position
	if distance and origin:
		distance -= 1.5
		dir.x = distance * cos(teta) + origin.x
		dir.y = distance * sin(teta) + origin.y
	else:
		dir = Vector2(0,0)

func _process(delta):
	if distance and origin:
		global_position = dir 
	
	if player and self.get_node("CollisionArea2D").overlaps_area(player.get_node("CollisionArea2D")) :
		player.collected_money += + value
		self.queue_free()
		print("money :" , player.collected_money)
	pass


func _on_interaction_area_area_entered(area):
	var object = area.get_parent()
	if object.name.find("player") !=-1 : 
		player = object
		distance = global_position.distance_to(player.global_position)
		origin = player.global_position
		teta = (global_position - player.global_position).angle()


func _on_interaction_area_area_exited(area):
	var object = area.get_parent()
	if object.name.find("player") !=-1 : 
		player = null
