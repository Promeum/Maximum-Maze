extends Node2D

@onready var bullet_path_1: Path2D = $BulletPaths/BulletPath1
@onready var bullet_path_2: Path2D = $BulletPaths/BulletPath2
@onready var bullet_path_3: Path2D = $BulletPaths/BulletPath3
@onready var bullet_path_4: Path2D = $BulletPaths/BulletPath4
@onready var bullet_container_1: Node = $BulletContainer/BulletContainer1
@onready var bullet_container_2: Node = $BulletContainer/BulletContainer2
@onready var bullet_container_3: Node = $BulletContainer/BulletContainer3
@onready var bullet_container_4: Node = $BulletContainer/BulletContainer4

@onready var player_path: Path2D = $PlayerPath
@onready var player: CharacterBody2D = $Player
@onready var camera_2d: Camera2D = $Camera2D

@export var player_position: int = 0

@onready var BULLET_PATHS = [bullet_path_1, bullet_path_2, bullet_path_3, bullet_path_4]
@onready var BULLET_CONTAINERS = [bullet_container_1, bullet_container_2, bullet_container_3, bullet_container_4]
var player_moving: bool = false
var queued_movement: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	move_player(0)
	GlobalSignals.player_battle_move_key_pressed.connect(move_player)

#func _physics_process(delta: float) -> void:
	#pass

func move_player(direction: int) -> void:
	var idx: int = player_position + direction
	if player_moving: # handle queued move
		queued_movement = clampi(queued_movement + direction, -1, 1)
	elif idx in range(0,player_path.curve.point_count):
		player_moving = true
		player_position = idx # player position variable set BEFORE player moves. Can be after though
		var timestep: float = 10/GlobalMethods.battle_player_speed()/player.position.distance_to(player_path.curve.get_point_position(idx))
		for coord in GlobalMethods.interpolated_points_list(
			player.position,
			player_path.curve.get_point_position(idx),
			10
			):
				player.position = coord
				await get_tree().create_timer(timestep).timeout
		player_moving = false
		if queued_movement != 0:
			var temp_queued_movement: int = queued_movement
			queued_movement = 0
			move_player(temp_queued_movement)

func spawn_attacks(attacks_to_spawn: int) -> void:
	var attacks_spawned: int = 0
	
	while attacks_spawned < attacks_to_spawn:
		attacks_spawned += int(place_attack(randi_range(0,3), GlobalVariables.attack_catalouge.keys().pick_random()))

func place_attack(idx: int, type: String, damage: int = -1, crit_chance: float = -1) -> bool:
	var attack: Dictionary
	attack = GlobalVariables.attack_catalouge.get(type).duplicate(true)
	if idx not in range(0,4):
		return false
	
	var attack_scene: Attack = GlobalVariables.attack_scene_catalouge.get(type).packed_scene.instantiate()
	
	attack_scene.type = type
	attack_scene.damage = damage if damage != -1 else attack.default_damage
	attack_scene.crit_chance = crit_chance if crit_chance != -1 else attack.crit_chance
	attack_scene.position = BULLET_PATHS[idx].curve.get_point_position(0)
	attack_scene.column = idx
	attack_scene.z_index += 1
	attack_scene.add_to_group("attacks")
	BULLET_CONTAINERS[idx].add_child(attack_scene)
	return true


func _on_attack_timer_timeout() -> void:
	spawn_attacks(2)
