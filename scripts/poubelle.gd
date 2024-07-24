extends Node2D

@onready var is_open = false
var is_closed
@onready var object_to_delete = null
@onready var interaction_area = $InteractionArea

# Called when the node enters the scene tree for the first time.
func _ready():
	is_closed = not is_open
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	is_closed = not is_open
	if not is_open or $Timer.get_time_left() > 0 : 
		$couvercle.position = Vector2(0,0)
		$couvercle.rotation = 0
	else :
		$couvercle.position = Vector2(0,-4)
		$couvercle.rotation = -25.8
	if object_to_delete : 
		open()
	else : 
		close()

func _input(event):
	if Input.is_action_just_pressed("ui_space") and object_to_delete:
		interact()

func open(): 
	is_open = true

func close(): 
	is_open = false

func interact():
	if object_to_delete :
		$Timer.start()
		close()
		object_to_delete


func _on_interaction_area_area_entered(area):
	var object = area.get_parent()
	print(object)
	if object and object.get_name().find("player") == -1 :
		object_to_delete = object


func _on_interaction_area_area_exited(area):
	var object = area.get_parent()
	if object and object.get_name().find("player") == -1 :
		object_to_delete = null

