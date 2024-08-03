extends AnimatedSprite2D

var wait_time = 3 #number iteration of animation
# Called when the node enters the scene tree for the first time.
var counter 
var animations = get_sprite_frames().get_animation_names()

func _ready():
	counter = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_animation_looped():
	counter +=1
	if counter == wait_time: 
		counter = 0 
		set_animation(animations[randi_range(0, len(animations)-1)])


