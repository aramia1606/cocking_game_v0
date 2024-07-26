extends Node2D
class_name Food



@export_category("Variables")
@export var cooker_name : String
@export_flags("chop") var state #coupé
@export var cooking_percentage: int 
@export var cooking_time: int
@export var start_burn: bool = false

@export_category("Nodes")
@export_subgroup("Nodes principal")
@export var sprite: Sprite2D
@export var interaction_area: InteractionArea
@export var cooking_timer: Timer
@export var timer : Timer
@export var time_bar: ProgressBar
@export_subgroup("Textures")
@export var rawTexture : Texture2D
@export var undercookedTexture : Texture2D
@export var cookedTexture : Texture2D
@export var burnTexture : Texture2D


var listTexture =[]
@onready var player = null
@onready var cooker = null
@onready var jugement = null
 
@onready var is_taken = false
@onready var is_in_cooker = false

@onready var cooking_state: CookingState = CookingState.RAW
@onready var isCooking = false
@onready var in_trash = false
@onready var to_judge = false

const wait_time = 3

enum CookingState {
RAW,
UNDERCOOKED,
GOOD,
PERFECT,
OVERCOOKED
}



func _ready():
	print(position)
	interaction_area.interact = Callable(self, "interact")
	listTexture = [rawTexture ,undercookedTexture,cookedTexture, cookedTexture, burnTexture]
	cooking_percentage = 0
	cooking_state = determine_cooking_state(cooking_percentage)


func _process(delta):
	cooking_percentage = get_cooking_percentage()
	cooking_state = determine_cooking_state(cooking_percentage)
	time_bar.value = cooking_percentage
	uptdate_texture(cooking_state)
	if is_in_cooker and cooker : 
		global_position = cooker.global_position
	elif  is_taken and player :
		global_position = player.position + Vector2(20,-10)
	
	if is_in_cooker and not in_trash:
		interaction_area.action_name = "arrêter la cuisson"
	elif is_taken and not in_trash:
		interaction_area.action_name = "poser"
	elif is_taken and in_trash:
		interaction_area.action_name = "jeter"
	elif cooker:
		interaction_area.action_name = "cuire"
	else :
		interaction_area.action_name = "prendre"


#func _physics_process(delta):
	#if isPicked : 
		#position = player.position + Vector2(20,-10)
#
#func interact():
	#isPicked = not isPicked
	#print("isPicked  =", isPicked)


func _physics_process(delta):
	pass


func manage_cooking():
		print(cooking_timer.get_time_left())
		print("Cooking percentage:" , cooking_percentage)
		if not isCooking:
			print("Début cuisson")
			cook(cooking_time)
		else : 
			print("Fin cuisson")
			stop_cooking()


	
func determine_cooking_state(percentage: float) -> CookingState:
	if not start_burn and percentage == 0:
		return CookingState.RAW
	elif not start_burn and percentage < 50:
		return CookingState.UNDERCOOKED
	elif percentage >= 50 and percentage < 90 :
		return CookingState.GOOD
	elif  percentage >= 90:
		return CookingState.PERFECT
	else :
		return CookingState.OVERCOOKED

func get_cooking_state() :
	return cooking_state


func cook(time_amount: int) -> void:
	time_bar.show()
	if cooking_timer.is_stopped() and cooking_state <= 1:
		print("start timer")
		cooking_timer.start(time_amount)
	else: 
		print("unpaused timer")
		cooking_timer.set_paused(false)
	isCooking = true

func stop_cooking() -> CookingState:
	time_bar.hide()
	cooking_timer.set_paused(true)
	isCooking = false
	return cooking_state

func get_cooking_percentage():
	var remaining_cooking_time = cooking_timer.get_time_left()
	if remaining_cooking_time > 0 and not start_burn:
		cooking_percentage = 100 * (cooking_time - remaining_cooking_time) / cooking_time
	elif remaining_cooking_time > 0 and start_burn:
		cooking_percentage = abs(100 * (remaining_cooking_time) / cooking_time)
	else:
		cooking_percentage = 0  # completely burnt
	return cooking_percentage


func uptdate_texture(state): #state va de 0 à 4
	$Sprite2D.set_texture(listTexture[state])

func interact():
	print("player holding:", player.is_holding_object, " object position:", position)
	if player and not player.is_holding_object :
		print("joueur prend et cuisson eventuel s'arrête")
		is_taken = true
		player.is_holding_object = true
		if isCooking : 
			stop_cooking()
			cooker.isFoodInside = false
			is_in_cooker = false
	else:
		print("joueur pose l'objet ou la cuisson commence")
		is_taken = false
		player.is_holding_object = false
		if cooker != null and not cooker.isFoodInside :
			print("Début de cuisson et dans la poele")
			is_in_cooker = true
			cook(cooking_time)
			position = cooker.position
			cooker.isFoodInside = true
		elif in_trash:
			remove_intsance()
		if to_judge:
			timer.start(wait_time)
			
			print("timer ,judge, not is taken, time left:",timer.get_time_left() )
			
	print("player holding:", player.is_holding_object, " object position:", position, "-----------")

func remove_intsance():
	if is_instance_valid(self) :
		is_taken = false
		if player :
			player.is_holding_object = false
		self.queue_free()
		print(self, ": instance supprimé")

func _on_interaction_area_body_entered(body):
	print("body entered food: ", body.name)
	if body.name.find("player") !=-1 : 
		print("player registered in food 's area")
		player = body

func _on_interaction_area_body_exited(body):
	if body.name.find("player") !=-1 : 
		player = null

func _on_pick_area_entered(area):
	var entered_object = area.get_parent()
	print("area entered in food's area :" , area.get_parent().name )
	if entered_object.name.find(cooker_name) != -1 :
		print("Pan entered in food's area :" , area.get_parent() )
		cooker = area.get_parent()
	if entered_object.name.find("poubelle") != -1:
		in_trash = true
	if entered_object.name.find("jugement_area")!= -1 : 
		to_judge = true
		jugement =  area
		

func _on_pick_area_exited(area):
	var entered_object = area.get_parent()
	if entered_object.name.find(cooker_name) != -1 :
		cooker = null
	if entered_object.name.find("poubelle") != -1:
		in_trash = false

func _on_timer_1_timeout():
	if not start_burn:
		print("Started to burn")
		start_burn = true
		cooking_timer.start
	else:
		cooking_timer.stop()



	pass # Replace with function body.


func _on_jugement_timeout():
	remove_intsance()
	jugement.spawn_coin(cooking_state)
	print("on judgmenet timout")
	
