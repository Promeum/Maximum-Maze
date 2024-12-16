extends Control

const GAME = preload("res://scenes/game.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GAME
	
	await get_tree().create_timer(1).timeout
	
	print ("aaaaaaaaaaaaaaaaaaaaaaa")
	preload("res://scenes/game.tscn").instantiate
	GlobalMethods.change_scene('game')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass 
	#if Input.is_action_just_pressed("Enter") == true:
		#print ("siiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiick")
