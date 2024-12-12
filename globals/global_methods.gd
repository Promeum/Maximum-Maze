extends Node

func change_scene(scene: String) -> void:
	if scene not in GlobalVariables.scene_list:
		push_error("Parameter scene is invalid! scene: '%s'" % scene)
		return
	GlobalVariables.scene = scene
	get_tree().change_scene_to_file("res://scenes/%s.tscn" % scene)
	#get_tree().change_scene_to_packed(vcvhfreg) # use this eventually

func convert_to_map_position(vec: Vector2i) -> Vector2i:
	return vec * GlobalVariables.MAZE_SCALE + Vector2i(GlobalVariables.MAZE_SCALE/2, GlobalVariables.MAZE_SCALE/2)

func interpolated_points_list(p1: Vector2, p2: Vector2, delta: float) -> PackedVector2Array:
	if sign(delta) != 1:
		push_error("Delta is not positive! delta: %s" % delta)
	
	var interpolated_points: Array
	var position: Vector2 = p1
	
	while position != p2:
		position = position.move_toward(p2, delta)
		interpolated_points.append(position)
	return interpolated_points

# use for cell wall monstrosity
func check_letters_in_string(string: String, letters: String) -> bool:
	for letter in letters:
		if letter not in string:
			return false
	return true

# repetitive speed access functions here

func maze_player_speed() -> float:
	return GlobalVariables.maze_speed * GlobalVariables.player_speed_mult

func maze_monster_speed() -> float:
	return GlobalVariables.maze_speed * GlobalVariables.monster_speed_mult

func battle_player_speed() -> float:
	return GlobalVariables.battle_speed * GlobalVariables.player_battle_speed_mult

func battle_attack_speed() -> float:
	return GlobalVariables.battle_speed * GlobalVariables.attack_speed_mult
