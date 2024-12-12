@icon("res://scenes/player_icon.png")
class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var weapon_point: Marker2D = $WeaponPoint

@export var health: int
@export var weapon: Weapon
@export var blocking: bool
@export var attacked: bool
@export var block_time: float = 0.5

func _ready() -> void:
	set_scale(Vector2(1,1) * GlobalVariables.MAZE_SCALE / sprite.texture.get_size())

func _physics_process(delta: float) -> void:
	move_and_slide()
	if Input.is_action_just_pressed("attack"):
		_on_attack_pressed()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent is Monster:
		print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
		if not blocking and not attacked:
			if randf() < parent.weapon.crit_chance:
				health -= parent.weapon.damage * 2
				print('health -%s -- Crit!' % (parent.weapon.damage*2))
				return
			health -= parent.weapon.damage
			print('health -%s!' % parent.weapon.damage)
			prints("health:",health)
			if health <= 0:
				GlobalSignals.player_died.emit()
			
			print("attacked")
			attacked = true
			sprite.modulate = Color8(255,0,0)
			
			if get_tree():
				await get_tree().create_timer(block_time).timeout
			
			attacked = false
			if blocking:
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

#func set_direction(direction: String):
	#if direction not in ['t', 'b', 'l', 'r']:
		#push_error("move_monster has invalid direction! direction: %s" % direction)
		#return false
	#
	#match direction:
		#'t': pass
		#'b': pass
		#'l':
			#weapon_point.set_position(Vector2i(-4,4))
			#weapon_point.get_child(0).set_scale(Vector2i(-1,1))
		#'r':
			#weapon_point.set_position(Vector2i(4,4))
			#weapon_point.get_child(0).set_scale(Vector2i(1,1))
	#return true

func _on_attack_pressed():
	if not blocking and not attacked:
		print("block")
		blocking = true
		sprite.modulate = Color8(0,0,255)
		
		await get_tree().create_timer(block_time).timeout
		
		blocking = false
		if attacked:
			sprite.modulate = Color8(255,0,0)
		else:
			sprite.modulate = Color8(255,255,255)
		print("unblock")
