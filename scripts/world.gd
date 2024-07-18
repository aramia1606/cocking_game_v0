extends Node2D

var object = load("res://scenes/object.tscn")
var nbInstance = 0
var listTexture = ["res://sprite/food and kitchenware icons/salade.png", "res://sprite/food and kitchenware icons/tomato.png"]
var texturePointer = 0
var listObject = []
var listInstance = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func new_instance():
	var new_object = object.instantiate()
	new_object.position = $player.position + Vector2(20, -10)
	new_object.name = "obj" + str(nbInstance)
	nbInstance += 1
	add_child(new_object)
	listObject.append(new_object)

func alternateTexture(sprite: Sprite2D):
	if texturePointer >= len(listTexture):
		texturePointer = 0
	sprite.texture = load(listTexture[texturePointer])
	texturePointer += 1

func has_collision():
	creatListInstance()  
	for instance in listInstance:
		var area = instance.get_node("interaction")
		if area and area.overlaps_area(get_node("player/Area2D")):
			return instance
	return null

func creatListInstance():
	listInstance.clear()
	for obj in listObject: 
		if obj.name.find("obj") != -1:
			listInstance.append(obj)

var collided_object = null

func _process(delta):
	collided_object = has_collision()
	
	listObject = get_children()
	if Input.is_action_just_pressed("ui_space"):
		print("Space")
		if not collided_object or nbInstance<=0:
			new_instance()
		else:
			var sprite_collided_object = collided_object.get_node("sprite")
			alternateTexture(sprite_collided_object)
	
	if collided_object:
		var collision = collided_object.get_node("collision")
		var sprite = collided_object.get_node("sprite")
		if Input.is_action_pressed("ui_w"):
			print("W")
			collision.disabled = true
			collided_object.position = $player.position
			sprite.position =  Vector2(10, -10)
		
		if Input.is_action_just_released("ui_w"):
			collision.disabled = false 
			collided_object.position = $player.position + Vector2(20, -10)
			sprite.position = Vector2(0,0)
