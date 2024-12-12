@icon("res://scenes/monsters/monster_icon.png")
class_name Monster extends CharacterBody2D

const BIDEM_DEBUG_MONSTER = preload("res://scenes/monsters/bidem_debug_monster.tscn")
const TRUNP_DEBUG_MONSTER = preload("res://scenes/monsters/trunp_debug_monster.tscn")
const SWORD_DEBUG_WEAPON = preload("res://scenes/weapons/sword_debug_weapon.tscn")

@onready var sprite: Sprite2D = $Sprite2D

@export var type: String
@export var health: int
@export var strength: int
@export var weapon: Weapon
@export var weapon_type: String
@export var pos: Vector2i

var movement_thread: Thread

func _ready() -> void:
	# if variable is different then change accordingly
	if health == -1:
		health = GlobalVariables.monster_catalouge.get(type).default_health
	if strength == -1:
		strength = GlobalVariables.monster_catalouge.get(type).strength
	if weapon_type == null:
		weapon_type = GlobalVariables.monster_catalouge.get(type).default_weapon_type
	if weapon == null:
		weapon = GlobalVariables.monster_catalouge.get(type).default_weapon.instantiate()
	
	if weapon.type == '' or weapon.type == null:
		weapon.type = weapon_type
	if weapon.damage == -1:
		weapon.damage = GlobalVariables.weapon_catalouge.get(weapon.type).default_damage
	if weapon.crit_chance == -1.0:
		weapon.crit_chance = GlobalVariables.weapon_catalouge.get(weapon.type).crit_chance
	
	#set_scale(Vector2(1,1) * GlobalVariables.MAZE_SCALE / sprite.texture.get_size())

func check_wall(direction: Vector2i) -> bool:
	var next_pos: Vector2i = pos + direction
	var next_cell: Dictionary = GlobalVariables.replicated_grid[next_pos.y][next_pos.x].duplicate(true)
	return next_pos.x in range(GlobalVariables.MAZE_X) and next_pos.y in range(GlobalVariables.MAZE_Y) and not next_cell.wall

func move_monster(direction: Vector2i) -> bool:
	#print(self)
	#prints("dir: ",direction,"vel: ",velocity,"pos: ",position)
	if velocity.length() != 0:
		#push_warning("Monster "+str(self.get_instance_id())+" still in motion!")
		return false
	
	if direction not in [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]:
		push_error("move_monster has invalid direction! direction: %s" % direction)
		return false
	
	if check_wall(direction):
		set_position(GlobalMethods.convert_to_map_position(pos))
		#prints(pos*16-Vector2i(8,8), "==", position)
		set_velocity(direction * GlobalVariables.MAZE_SCALE * GlobalMethods.maze_monster_speed())
		movement_thread = Thread.new()
		movement_thread.start(move_monster_assist.bind(pos+direction))
		return true
	push_warning("move_monster next_pos not valid!")
	return false

func move_monster_assist(destination_pos: Vector2i):
		await get_tree().create_timer(1/GlobalMethods.maze_monster_speed()).timeout
		set_velocity(Vector2(0,0))
		set_position(GlobalMethods.convert_to_map_position(destination_pos))
		pos = destination_pos
		call_deferred("end_thread")

func end_thread():
	movement_thread.wait_to_finish()
	movement_thread = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	move_and_slide()
