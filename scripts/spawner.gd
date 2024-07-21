extends Node2D
class_name Spawner

@export_category("Propriétés")
@export_file("*.tscn") var object_to_spawn_directory 

@export_category("Nodes")
@export var sprite: Sprite2D
@export var interaction_area: InteractionArea

var object = null
var player = null
var nbInstance = 0
var listObject = []
# Called when the node enters the scene tree for the first time.
func _ready():
	print(object_to_spawn_directory)
	object = load(object_to_spawn_directory)
	print(object)
	interaction_area.interact = Callable(self, "interact")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_instance():
	var new_object = object.instanciate()
	#new_object.just_spawned = true
	##new_object.position = player.position
	##new_object.is_taken = true
	##player.is_holding_object = true
	new_object.name = new_object.name + str(nbInstance)
	nbInstance += 1
	add_child(new_object)
	listObject.append(new_object)
	new_object.set_as_toplevel(true)
	new_object.global_position = global_position
	print(new_object)


func interact():
	new_instance()


func _on_interaction_area_body_entered(body):
	print("body entered spawner: ", body.name)
	if body.name.find("player") !=-1 : 
		print("player registered in spawner's area")
		player = body


func _on_interaction_area_body_exited(body):
	if body.name.find("player") !=-1 : 
		player = null
