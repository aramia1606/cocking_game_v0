extends StaticBody2D
class_name pickableObject 

var player = null
var interaction_area 
var isHolded = false

func _ready():
	interaction_area = $InteractionArea
	interaction_area.interact = Callable(self, "interact")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isHolded and player : 
		global_position = player.global_position + Vector2(20,-10)

func interact():
	isHolded = not isHolded

func _on_interaction_area_body_entered(body):
	$Label.visible = true
	if body.name.find("player") != -1 :
		player = body
	pass # Replace with function body.


func _on_interaction_area_body_exited(body):
	$Label.visible = false
	if body.name.find("player") != -1 :
		player = null
	pass # Replace with function body.
