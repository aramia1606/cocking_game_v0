extends Node2D
class_name Spawner

@export_category("Propriétés")
@onready var scene_paths = {
	0: "res://scenes/gameplay/viande.tscn",
	#"poulet": "res://scenes/poulet.tscn"
}

@export_enum("Viande:0") var object_to_spawn : int
@export_category("Nodes")
@export var sprite: Sprite2D
@export var interaction_area: InteractionArea

const listObject_path = ["res://scenes/gameplay/viande.tscn"]
var object = null
var player = null
var nbInstance = 0
var listObject = []
var object_to_spawn_path
# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "interact")
	object_to_spawn_path = scene_paths.get(object_to_spawn)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func new_instance():
	var new_object = load(object_to_spawn_path).instantiate()
	new_object.global_position = Vector2(0, 25)
	new_object.global_position += Vector2( randi_range(-10, 10), randi_range(-10,10) )
	#penser au z-index
	new_object.name = "viande" + str(nbInstance)
	nbInstance += 1
	add_child(new_object)
	listObject.append(new_object)



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
