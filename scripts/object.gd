extends StaticBody2D
class_name pickableObject 


@export_enum("Tomate", "Salade") var nameObject: String = "Tomate"
var dictTextures = {"Tomate": "res://sprite/food and kitchenware icons/salade.png", "Salade": "res://sprite/food and kitchenware icons/tomato.png"}


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_interaction_body_entered(body):
	$Label.visible = true


func _on_interaction_body_exited(body):
	$Label.visible = false
	#playerPosition = body.get_position()

