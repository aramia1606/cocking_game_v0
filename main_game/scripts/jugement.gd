extends Area2D

@onready var objects_in_area = []
var object_to_interact
var player 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


const reaction = {0: ["Eww", "Seriously ?", ">:(", "Are you crazy !?", "Dude ...", "Resset"], 
1: ["Not bad", "Good"] , 
2 : ["Nice job", "Delicious", "Gorgeous"] , 
3 : ["Perfect !", "Awesome !", "Amazing !"] , 
4 : ["Eurk", "...", "Kinda burn..." , "Bad", "Ugly", "Resset"]} 


func spawn_coin(number):
	var nb_piece = { 0:randi_range(0,3) , 1:randi_range(1,5) , 2:randi_range(3,6) , 3:randi_range(3,10,), 4: randi_range(0,4)}
	for i in range(nb_piece.get(number)):
		new_instance("res://scenes/gameplay/piece.tscn" , "piece")
	$"../Label".show()
	var comments =  reaction.get(object_to_interact.get_cooking_state())
	$"../Label".text = comments.pick_random()
	$"../Timer".start()
	print("timer started")



var nbInstance = 0
var listObject = []

func new_instance(object_to_spawn_path, name_ : String):
	var new_object = load(object_to_spawn_path).instantiate()
	new_object.global_position = $CollisionShape2D.position
	new_object.global_position += Vector2( randi_range(-10, 10), randi_range(-10,10) )
	#penser au z-index
	new_object.name = name_ + str(nbInstance)
	nbInstance += 1
	add_child(new_object)
	listObject.append(new_object)
	print("new instance coin")

func _on_interaction_area_area_entered(area):
	var object = area.get_parent()
	print(object)
	if object and object.get_name().find("viande") != -1 :
		object_to_interact = object
	if object and object.get_name().find("player") != -1 :
		player = object


func _on_interaction_area_area_exited(area):
	var object = area.get_parent()
	if object and object.get_name().find("player") == -1 :
		object_to_interact = null
	if object and object.get_name().find("player") != -1 :
		player = null


func _on_timer_timeout():
	$"../Label".hide()
	print("timer out")
	pass # Replace with function body.

func place_object(object):
	if object.get_groups().find("food") != -1:
		objects_in_area.append(object)
