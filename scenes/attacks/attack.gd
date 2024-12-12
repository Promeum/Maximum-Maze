@icon("res://scenes/attacks/attack_icon.png")
class_name Attack extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

@export var type: String
@export var damage: int
@export var column: int
@export var crit_chance: float
@export var vel: float = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if type != null and type != '':
		pass
	else:
		push_error("Weapon has no type!")
	velocity = Vector2i(0,vel)
	set_scale(Vector2(10,10) * GlobalVariables.BATTLE_SCALE / sprite.texture.get_size())

func _physics_process(delta: float) -> void:
	velocity = Vector2i(0,vel)
	move_and_slide()
