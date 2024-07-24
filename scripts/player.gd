extends CharacterBody2D

const SPEED = 100
var current_SPEED = SPEED
const factor_SPEED_acc = 1.8
var is_holding_object = false
var object = null

func _ready():
	$AnimatedSprite2D.play("idle")
	
	
func _physics_process(delta):
	player_movement(delta)
	

func player_movement(delta):
	var x_axis = Input.get_axis("ui_left" , "ui_right")
	var y_axis = Input.get_axis("ui_up" , "ui_down")
	var acceleration = Input.is_key_pressed(KEY_SHIFT)
	
	if acceleration == true : 
		current_SPEED = SPEED * factor_SPEED_acc
	else :
		current_SPEED = SPEED

	if x_axis != 0 and y_axis ==0 : 
		velocity = Vector2(current_SPEED * x_axis , 0)
	elif x_axis == 0 and y_axis != 0 :
		velocity = Vector2(0 , current_SPEED * y_axis )
	elif x_axis != 0 and y_axis != 0 :
		velocity = Vector2((current_SPEED / sqrt(2)) * x_axis, (current_SPEED / sqrt(2)) * y_axis)
	else : 
		velocity = Vector2(0,0)
	play_anim(x_axis , y_axis, acceleration)
	move_and_slide()	

func isFliped(x_axis):
	if x_axis >= 0 :
		return false
	else :
		return true 

func play_anim(x_axis , y_axis, acceleration) :
	var anim = $AnimatedSprite2D
	if x_axis == 0 and y_axis ==0 :
		anim.play("idle")
	else : 
		anim.flip_h = isFliped(x_axis)
		if acceleration == false :
			anim.play("walk")
		else :
			anim.play("run")



func _on_area_2d_area_entered(area):
	if area.get_parent().name.find("viande") != -1:
		object = area.get_parent()
	pass # Replace with function body.


func _on_area_2d_area_exited(area):
	if area.get_parent().name.find("viande") != -1:
		object = null
	pass # Replace with function body.
