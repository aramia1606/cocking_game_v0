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
@export var time_bar: ProgressBar
@export_subgroup("Textures")
@export var rawTexture : Texture2D
@export var undercookedTexture : Texture2D
@export var cookedTexture : Texture2D
@export var burnTexture : Texture2D

var listTexture =[]
var player = null
var cooker = null

var just_spawned 
var is_taken = false
var is_in_cooker = false

var cooking_state: CookingState = CookingState.RAW
var isCooking = false

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
	if just_spawned and player: 
		#position = player.position + Vector2(20,-10)
		just_spawned = false
	cooking_percentage = get_cooking_percentage()
	cooking_state = determine_cooking_state(cooking_percentage)
	time_bar.value = cooking_percentage
	uptdate_texture(cooking_state)
	if is_in_cooker and cooker : 
		position = cooker.position
	elif  is_taken and player :
		position = player.position + Vector2(20,-10)


#func _physics_process(delta):
	#if isPicked : 
		#position = player.position + Vector2(20,-10)
#
#func interact():
	#isPicked = not isPicked
	#print("isPicked  =", isPicked)

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

func _on_timer_1_timeout():
	if not start_burn:
		print("Started to burn")
		start_burn = true
		cooking_timer.start
	else:
		cooking_timer.stop()

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
	print("player holding:", player.is_holding_object, " object position:", position, "-----------")

func _on_interaction_area_body_entered(body):
	print("body entered food: ", body.name)
	if body.name.find("player") !=-1 : 
		print("player registered in food 's area")
		player = body


func _on_interaction_area_body_exited(body):
	if body.name.find("player") !=-1 : 
		player = null


func _on_pick_area_entered(area):
	print("area entered in food's area :" , area.get_parent().name )
	if area.get_parent().name.find(cooker_name) != -1 :
		print("Pan entered in food's area :" , area.get_parent() )
		cooker = area.get_parent()


func _on_pick_area_exited(area):
	if area.get_parent().name.find(cooker_name) != -1 :
		cooker = null
