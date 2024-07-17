extends StaticBody2D
#var isHold = false
#var playerPosition
#var objectPosition = $".".get_position


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func holding_process(delta): 
	#print(isHold, playerPosition)
	#if Input.is_action_pressed("ui_space"):
		#isHold = not isHold
		#print("Space pressed")
	#if isHold == true and playerPosition != null : 
		#$".".global_position = playerPosition + Vector2(5 , -10)
		#$collision.disabled = true
		#$Label.visible = false
	#else : 
		#$collision.disabled = false
		
func _on_interaction_body_entered(body):
	$Label.visible = true


func _on_interaction_body_exited(body):
	$Label.visible = false
	#playerPosition = body.get_position()

