extends Node2D
class_name Tool

@export_category("Variables")
@export_enum("Cut", "Cook") var use 

@export_category("Nodes")
@export var sprite: Sprite2D
@export var interaction_area: InteractionArea

@onready var is_used = false
var isFoodInside = false
var object_in 

func _ready():
	#interaction_area.interact = Callable(self, "interact")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if isFoodInside and food:
		#food.position = position
	pass

func cut(object):
	if use == 0 and object.get_groups().find("food") != -1 :
		is_used = true
		object_in = object 
		object.can_interact = false
		print("cant interact")
		$ProgressBar2.show()
		if $Timer.get_time_left() > 0 :
			print("timer paused")
			$Timer.set_paused(false)
		else :
			print("timer start")
			$Timer.start()

func stop_cut(object):
	is_used = false
	$Timer.set_paused(true)
	object_in.can_interact = true
	print("can interact")
	$ProgressBar2.hide()
	object_in = null

func _on_timer_timeout():
	is_used = false
	print(object_in, " is choped")
	object_in.is_choped = true
	object_in.can_interact = true
	print("can interact")
	$ProgressBar2.hide()
	object_in = null
