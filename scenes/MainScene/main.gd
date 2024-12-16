extends Control



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void: 
	if Input.is_action_just_pressed("Enter") == true:
		GlobalMethods.change_scene('loading')
		print ("ahfgkeajgbafdad")
		
		#await get_tree().create_timer(1).timeout
		#print ("aaaaaaaaaaaaaaaaaaaaaaa")
		#GameManager.load_game_scene()
