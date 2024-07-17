extends Node2D
var object = load("res://scenes/object.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
func new_intance(delta):
	if Input.is_action_just_pressed("ui_space"):
		print("Space")
		#if Input.is_action_pressed("ui_space"):
		var new_object = object.instantiate()
		new_object.position = $player.position
		add_child(new_object)
# Appelée chaque frame. 'delta' est le temps écoulé depuis la frame précédente.
func _process(delta):
	new_intance(delta)
