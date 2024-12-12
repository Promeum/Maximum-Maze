extends Node2D

const CELL = preload("res://scenes/cells/cell.tscn")

@onready var monster_container: Node = $MonsterContainer
@onready var wall_container: Node = $WallContainer
@onready var border_container: Node = $WallContainer/BorderContainer
@onready var open_cell_container: Node = $OpenCellContainer
@onready var solution_cell_container: Node = $OpenCellContainer/SolutionCellContainer

@onready var player: CharacterBody2D = $Player
@onready var player_move_timer: Timer = $PlayerMoveTimer
@onready var monster_move_timer: Timer = $MonsterMoveTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# maze generation related variables

var grid: Array
var maze_solution: Array
@export var walls_to_eliminate: int
@export var monsters_to_spawn: int = 200

# monster motion relate variables
var directions: Array = [Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0), Vector2i(0,-1)]
var move_monster_thread_list: Array = []

# player motion relate variables
@export var player_pos: Vector2i = Vector2i(1, 1) # index in grid
var movement_direction: String # up down left right

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Note: These are hardcoded values, need to change eventually
	GlobalVariables.MAZE_X = get_viewport_rect().size.x/GlobalVariables.MAZE_SCALE -1
	GlobalVariables.MAZE_Y = get_viewport_rect().size.y/GlobalVariables.MAZE_SCALE -1
	walls_to_eliminate = 130
	# ###########################################################
	generate_maze()
	GlobalVariables.replicated_grid = grid
	GlobalVariables.replicated_maze_solution = maze_solution
	show_maze()
	spawn_monsters(monsters_to_spawn)
	
	player_move_timer.wait_time = 1/ GlobalMethods.maze_player_speed()
	await get_tree().create_timer(1).timeout # for testing
	move_player()
	player_move_timer.timeout.connect(move_player)
	monster_move_timer.start(1/GlobalMethods.maze_monster_speed()+0.01)
	monster_move_timer.timeout.connect(move_monsters)
	GlobalSignals.player_died.connect(_on_player_died)

func generate_maze() -> void:
	# instantiate grid
	for row_index in range(GlobalVariables.MAZE_Y):
		var row: Array
		for col_index in range(GlobalVariables.MAZE_X):
			var cell: Dictionary = {'pos': {'x': col_index, 'y': row_index}, 'done': false, 'solution': false}
			if row_index == 0 or row_index == GlobalVariables.MAZE_Y - 1 or col_index == 0 or col_index == GlobalVariables.MAZE_X - 1:
				cell.border = true
				cell.wall = true
			elif bool(row_index % 2 - 1) or bool(col_index % 2 - 1):
				cell.border = false
				cell.wall = true
			else:
				cell.border = false
				cell.wall = false
			row.append(cell)
		grid.append(row)
	
	# For debugging purposes
	var iteration: int = 1
	
	var traceback: bool = false # Activates the traceback mechanism to make the maze grow a new branch
	var cell_path: Array # Assists in traceback mechanism
	var possible_maze_solution: Array = [{'x': 1, 'y': 1}]
	var found_solution: bool = false
	var current: Dictionary = grid[1][1]
	while true:
		#await get_tree().create_timer(0.01).timeout
		var cell: Dictionary # This cell is not a reference to grid and shall not be used to modify grid
		var possible: Dictionary # Used to check if possible_cell will be within bounds of grid
		var rand_direction: int # value chosen by weighted randomness, 0-b, 1-l, 2-t, 3-r
		var temp_rand_direction: float = randf()
		if temp_rand_direction >= 0.95:   # 5% for b
			rand_direction = 0
		elif temp_rand_direction >= 0.80: # 15% for r
			rand_direction = 1
		elif temp_rand_direction >= 0.45: # 35% for t
			rand_direction = 2
		else:                             # 45% for l
			rand_direction = 3
		
		if not traceback:
			cell_path.append({'pos': current.pos.duplicate()})
		else:
			var popped_cell = cell_path.pop_back()
			current = grid[popped_cell.pos.y][popped_cell.pos.x]
			if not found_solution:
				possible_maze_solution.pop_back()
				possible_maze_solution.pop_back()
			#print('    Popped cell at %s' % popped_cell)
		
		# this loop tries a random direction then tries the other 3 directions one by one
		# if it fails to find an open cell
		for attempt in range(4):
			if traceback and len(cell_path) == 0: break
			possible = {'pos': cell_path[-1].pos.duplicate()}
			var choice = (rand_direction + attempt) % 4
			if bool(choice % 2):
				possible.pos.x += int(choice == 1)*4-2 # 2 or -2
				if possible.pos.x > 0 and possible.pos.x < GlobalVariables.MAZE_X - 1: # check for within grid bounds
					var possible_cell: Dictionary = grid[possible.pos.y][possible.pos.x]
					if not possible_cell.done and not possible_cell.wall and not possible_cell.border: # check for cell attributes
						cell = possible_cell.duplicate(true)
						# forge the path!
						grid[cell.pos.y][cell.pos.x-(int(choice == 1)*2-1)].done = true
						grid[cell.pos.y][cell.pos.x-(int(choice == 1)*2-1)].wall = false
						if traceback: traceback = false
						if not found_solution:
							possible_maze_solution.append(grid[cell.pos.y][cell.pos.x-(int(choice == 1)*2-1)].pos.duplicate())
							possible_maze_solution[-1].direction = 'r' if choice == 1 else 'l'
							possible_maze_solution.append(cell.pos.duplicate())
							possible_maze_solution[-1].direction = 'r' if choice == 1 else 'l'
							if current.pos == {'x': GlobalVariables.MAZE_X - 2, 'y': GlobalVariables.MAZE_Y - 2}:
								found_solution = true
						break
			else:
				possible.pos.y += int(choice == 0)*4-2 # 2 or -2
				if possible.pos.y > 0 and possible.pos.y < GlobalVariables.MAZE_Y - 1: # check for within grid bounds
					var possible_cell = grid[possible.pos.y][possible.pos.x]
					if not possible_cell.done and not possible_cell.wall and not possible_cell.border: # check for cell attributes
						cell = possible_cell.duplicate(true)
						# forge the path!
						grid[cell.pos.y-(int(choice == 0)*2-1)][cell.pos.x].done = true
						grid[cell.pos.y-(int(choice == 0)*2-1)][cell.pos.x].wall = false
						if traceback: traceback = false
						if not found_solution:
							possible_maze_solution.append(grid[cell.pos.y-(int(choice == 0)*2-1)][cell.pos.x].pos.duplicate())
							possible_maze_solution[-1].direction = 'b' if choice == 0 else 't'
							possible_maze_solution.append(cell.pos.duplicate())
							possible_maze_solution[-1].direction = 'b' if choice == 0 else 't'
							if current.pos == {'x': GlobalVariables.MAZE_X - 2, 'y': GlobalVariables.MAZE_Y - 2}:
								found_solution = true
								break
						break
			
			if attempt == 3 and not traceback: traceback = true
			iteration += 1
			
			#print('    Attempt %s fail...\n      Current: %s\n      Possible: %s' % [attempt, current, possible] + '\n    Iteration fail! Activating traceback mechanism...' if attempt == 3 else '')
		
		#print('Iteration %s Results:\n  Previous: %s\n  New cell: %s\n____________________________' % [iteration, current, cell])
		if traceback and len(cell_path) == 0:
			maze_solution = possible_maze_solution.duplicate(true)
			#print(maze_solution)
			push_error("Maze Complete")
			break
		#elif traceback:
			#print('Traceback active...')
			#i love lasagna labyrinth
		elif not traceback and cell == { }:
			push_error('Did not pick a cell!')
			#print('Did not pick a cell!')
		elif not cell == { }:
			current.done = true
			current = grid[cell.pos.y][cell.pos.x]
	
	for row in grid: for cell in row: # make all of the cells in the solution path have solution == true
		for scell in maze_solution:
			if {'x': scell.x, 'y': scell.y} == cell.pos:
				cell.solution = true
	for cell in maze_solution:
		cell.solution = true
	
	# delete some random walls to add confusion
	var walls_eliminated: int = 0
	var grid_of_unharmed_cells = grid.duplicate(true)
	var y: int
	var x: int
	while walls_eliminated < walls_to_eliminate:
		var random_cell: Dictionary = grid_of_unharmed_cells.pick_random().pick_random()
		if random_cell.wall and not random_cell.border:
			var cell_pos = grid[random_cell.pos.y][random_cell.pos.x]
			if cell_pos:
				cell_pos.wall = false
				walls_eliminated += 1
			else:
				push_error('random_cell not in grid\n'+str(random_cell))
				break

func show_maze(print_to_console: bool = false):
	if print_to_console:
		for r in grid:
			var g = ''
			for p in r:
				g += ('B' if p.border else ('#' if p.wall else ('O' if p.solution else (' ' if p.done else 'X'))))
			print(g)
	else:
		# put the cells on the screen
		var p: Dictionary
		
		for i in range(len(grid)):
			for o in range(len(grid[0])):
				p = grid[i][o]
				#print( "pos (" + str(p.pos.x) + ", " + str(p.pos.y) + ") = ("+str(o)+", "+str(i)+")")
				var new_cell: Cell = CELL.instantiate()
				new_cell.grid_index = p.pos.duplicate()
				
				new_cell.position = GlobalMethods.convert_to_map_position(Vector2i(p.pos.x, p.pos.y))
				new_cell.add_to_group("cells")
				
				if p.border:
					new_cell.type = 'border'
					border_container.add_child(new_cell)
				elif p.wall:
					new_cell.type = 'wall'
					wall_container.add_child(new_cell)
				elif p.solution:
					new_cell.type = 'solution'
					solution_cell_container.add_child(new_cell)
				else:
					new_cell.type = 'open_cell'
					open_cell_container.add_child(new_cell)

func spawn_monsters(monsters_to_spawn: int) -> void:
	var monsters_spawned: int = 0
	var positions_tried: Array
	
	while monsters_spawned < monsters_to_spawn:
		positions_tried.append(Vector2i(randi_range(0,GlobalVariables.MAZE_X-1), randi_range(0,GlobalVariables.MAZE_Y-1)))
		monsters_spawned += int(place_monster(positions_tried[-1], GlobalVariables.monster_catalouge.keys().pick_random()))
	#prints(monsters_spawned,"monsters spawned")

func place_monster(pos: Vector2i, type: String, health: int = -1, strength: int = -1, weapon: String = '') -> bool:
	var monster: Dictionary
	monster = GlobalVariables.monster_catalouge.get(type).duplicate(true)
	if monster == null or grid[pos.y][pos.x].wall:
		return false
	
	var monster_scene: Monster = GlobalVariables.monster_scene_catalouge.get(type).duplicate(true).packed_scene.instantiate()
	
	monster_scene.type = type
	monster_scene.health = health
	monster_scene.strength = strength
	monster_scene.weapon_type = weapon
	monster_scene.pos = pos
	monster_scene.position = GlobalMethods.convert_to_map_position(pos)
	monster_scene.z_index += 1
	monster_scene.add_to_group("monsters")
	monster_container.add_child(monster_scene)
	return true

func move_player():
	if player_pos != Vector2i(GlobalVariables.MAZE_X - 2, GlobalVariables.MAZE_Y - 2):
		var destination = maze_solution[GlobalVariables.player_progress+1].duplicate()
		player.position = GlobalMethods.convert_to_map_position(player_pos)
		
		if maze_solution[GlobalVariables.player_progress+1].has('direction'):
			#print(destination.direction)
			match destination.direction:
				't': player.velocity = Vector2(0,-GlobalVariables.MAZE_SCALE*GlobalMethods.maze_player_speed())
				'b': player.velocity = Vector2(0,GlobalVariables.MAZE_SCALE*GlobalMethods.maze_player_speed())
				'l': player.velocity = Vector2(-GlobalVariables.MAZE_SCALE*GlobalMethods.maze_player_speed(),0)
				'r': player.velocity = Vector2(GlobalVariables.MAZE_SCALE*GlobalMethods.maze_player_speed(),0)
			#player.set_direction(destination.direction)
		player_pos = Vector2i(destination.x, destination.y)
		
		GlobalVariables.player_progress += 1
	else:
		player_move_timer.stop()
		player.velocity = Vector2(0,0)
		GlobalVariables.player_progress = -1
		push_error("Player at end!")

func move_monsters():
	for i in range(monster_container.get_child_count()):
		var monster: Monster = monster_container.get_child(i)
		if player_pos.distance_to(monster.pos) < 9:
			# this loop tries a random direction then tries the other
			# 3 directions one by one if it fails to find an open cell
			var possible_direction: int = randi_range(0,3)
			var direction: Vector2i
			for attempt in range(5):
				#print(direction)
				if attempt == 4:
					push_warning("Could not move monster to open spot!")
					break
				possible_direction = (possible_direction+attempt)%4
				direction = directions[possible_direction]
				if monster.check_wall(direction):
					break
			#print("pre-monster move:  %s" % i)
			move_monster_thread_list.append(Thread.new())
			move_monster_thread_list[-1].start(
				monster.move_monster.bind(direction)
			)
			#print("post-monster move: %s" % i)
	for i in range(len(move_monster_thread_list)-1, -1, -1):
		var thread: Thread = move_monster_thread_list[i]
		#prints("waiting on thread ",thread)
		await thread.wait_to_finish()
		move_monster_thread_list.pop_at(i)

func _on_player_died() -> void:
	 #for debugging the fancy zoom animation
	animation_player.play('zoom_transition', -1, 0.7)
	animation_player.animation_finished.connect(GlobalMethods.change_scene.bind('battle').unbind(1))
	player_move_timer.stop()
	monster_move_timer.stop()
