@icon("res://scenes/weapons/weapon_icon.png")
class_name Weapon extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

@export var type: String
@export var damage: int = -1
@export var crit_chance: float = -1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if type != null and type != '':
		pass
	else:
		push_error("Weapon has no type!")
	
	if damage == -1:
		damage = GlobalVariables.weapon_catalouge.get(type).default_damage
	if crit_chance == -1.0:
		crit_chance = GlobalVariables.weapon_catalouge.get(type).crit_chance
	
	#set_scale(Vector2(1,1) * GlobalVariables.MAZE_SCALE / sprite.texture.get_size())
