extends Area2D
class_name InteractionArea 

@export var action_name : String = "interact"



var interact: Callable = func():
	pass


func _on_body_entered(body):
	print("body enterd from interaction")
	InteractionManager.register_area(self)


func _on_body_exited(body):
	print("body exited from interaction")
	InteractionManager.unregister_area(self)


func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.
