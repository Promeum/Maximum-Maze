@icon("res://scenes/player_battle_icon.png")
class_name PlayerBattle extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D

@export var health: int
@export var weapon: Weapon
@export var parrying: bool
@export var attacked: bool
@export var block_time: float = 0.5

func _ready() -> void:
	set_scale(Vector2(1,1) * GlobalVariables.BATTLE_SCALE / sprite.texture.get_size() / 3)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("battle_left"):
		GlobalSignals.player_battle_move_key_pressed.emit(-1)
	elif Input.is_action_just_pressed("battle_right"):
		GlobalSignals.player_battle_move_key_pressed.emit(1)
	
	move_and_slide()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Attack:
		print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
		if not parrying and not attacked:
			if randf() < parent.crit_chance:
				health -= parent.damage * 2
				print('health -%s -- Crit!' % (parent.damage*2))
				return
			health -= parent.damage
			print('health -%s!' % parent.damage)
			prints("health:",health)
			if health <= 0:
				GlobalSignals.player_died.emit()
			
			print("attacked")
			attacked = true
			sprite.modulate = Color8(255,0,0)
			
			await get_tree().create_timer(block_time).timeout
			
			attacked = false
			if parrying:
				sprite.modulate = Color8(0,0,255)
			else:
				sprite.modulate = Color8(255,255,255)
			print("unattacked")
		else:
			print("yayyyy")
			area.modulate = Color8(222,255,222)
			area.queue_free()
			#await get_tree().create_timer(block_time).timeout
			
			#area.modulate = Color8(255,255,255)
