extends Node2D
class_name Tool

@export_category("Variables")
@export_enum("Cut", "Cook") var use 

@export_category("Nodes")
@export_subgroup("Nodes principal")
@export var sprite: Sprite2D
@export var interaction_area: InteractionArea

var isFoodInside = false

func _ready():
	#interaction_area.interact = Callable(self, "interact")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if isFoodInside and food:
		#food.position = position
	pass


