extends Node

var scene_list = ['game', 'battle', 'menu']
@export var scene: String = 'game' # temporarily hardcoded
@export var points: int = 0

# maze-related variables
@export var MAZE_SCALE: int = 16
@export var MAZE_X: int
@export var MAZE_Y: int
@export var maze_speed: float = 1.3 # this is a multiplier
@export var player_speed_mult: float = 1.0 # this is a multiplier
@export var monster_speed_mult: float = 0.8 # this is a multiplier

@export var player_progress: int = 0 # this is an index in maze_solution
@export var replicated_grid: Array = []
@export var replicated_maze_solution: Array = []

# battle-related variables
@export var BATTLE_SCALE: int = 16 * 7 # 16x16 sprites @ x7 scale

@export var battle_speed: float = 1.3 # this is a multiplier
@export var player_battle_speed_mult: float = 1.0 # this is a multiplier
@export var attack_speed_mult: float = 1.0 # this is a multiplier

var monster_catalouge: Dictionary = {
	'bidem_debug_monster': {
		'default_health': 2,
		'default_weapon_type': 'sword_debug_weapon',
		'default_weapon': preload("res://scenes/weapons/sword_debug_weapon.tscn"),
		'strength': 1,
		'speed': 1
	},
	'trunp_debug_monster': {
		'default_health': 3,
		'default_weapon_type': 'sword_debug_weapon',
		'default_weapon': preload("res://scenes/weapons/sword_debug_weapon.tscn"),
		'strength': 2,
		'speed': 1
	},
	'minitaur': {
		'default_health': 1,
		'default_weapon_type': 'wooden_leg',
		'default_weapon': preload("res://scenes/weapons/wooden_leg.tscn"),
		'strength': 2,
		'speed': 1.05
	},
	'john': {
		'default_health': 1,
		'default_weapon_type': 'sword_shaped_stick',
		'default_weapon': preload("res://scenes/weapons/sword_shaped_stick.tscn"),
		'strength': 1,
		'speed': 1.3
	},
	'skeleton_wizard': {
		'default_health': 2,
		'default_weapon_type': 'sword_shaped_stick',
		'default_weapon': preload("res://scenes/weapons/sword_shaped_stick.tscn"),
		'strength': 1,
		'speed': 1
	}
}

var monster_scene_catalouge: Dictionary = {
	'bidem_debug_monster': {
		'packed_scene': preload("res://scenes/monsters/bidem_debug_monster.tscn")
	},
	'trunp_debug_monster': {
		'packed_scene': preload("res://scenes/monsters/trunp_debug_monster.tscn")
	},
	'minitaur': {
		'packed_scene': preload("res://scenes/monsters/minitaur.tscn")
	},
	'john': {
		'packed_scene': preload("res://scenes/monsters/minitaur.tscn")
	},
	'skeleton_wizard': {
		'packed_scene': preload("res://scenes/monsters/skeleton_wizard.tscn")
	}
}

var weapon_catalouge: Dictionary = {
	'sword_debug_weapon': {
		'default_damage': 1,
		'crit_chance': 0.05
	},
	'axe_basic': {
		'default_damage': 4,
		'crit_chance': 0.13
	},
	'axe_battle': {
		'default_damage': 6,
		'crit_chance': 0.17
	},
	'wooden_leg': {
		'default_damage': 1,
		'crit_chance': 0.01
	},
	'sword_shaped_stick': {
		'default_damage': 1,
		'crit_chance': 0.05
	}
}

var weapon_scene_catalouge: Dictionary = {
	'sword_debug_weapon': {
		'packed_scene': preload("res://scenes/weapons/sword_debug_weapon.tscn")
	},
	'axe_basic': {
		'packed_scene': preload("res://scenes/weapons/axe_basic.tscn")
	},
	'axe_battle': {
		'packed_scene': preload("res://scenes/weapons/axe_battle.tscn")
	},
	'wooden_leg': {
		'packed_scene': preload("res://scenes/weapons/wooden_leg.tscn")
	},
	'sword_shaped_stick': {
		'packed_scene': preload("res://scenes/weapons/sword_shaped_stick.tscn")
	}
}

var attack_catalouge: Dictionary = {
	'bullet_debug_attack': {
		'default_damage': 1,
		'crit_chance': 0.05
	}
}

var attack_scene_catalouge: Dictionary = {
	'bullet_debug_attack': {
		'packed_scene': preload("res://scenes/attacks/bullet_debug_attack.tscn")
	}
}
