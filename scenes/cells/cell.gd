@icon("res://scenes/cells/cell_icon.png")
class_name Cell extends Sprite2D

const BORDER_PROGRAMMER_ART = preload("res://assets/debug_assets/border_programmer_art.png")
const OPEN_CELL_PROGRAMMER_ART = preload("res://assets/debug_assets/open_cell_programmer_art.png")
const PATH_PROGRAMMER_ART = preload("res://assets/debug_assets/path_programmer_art.png")
const WALL_PROGRAMMER_ART = preload("res://assets/debug_assets/wall_programmer_art.png")

const BLANK_TILE = preload("res://assets/tiles/BlankTile.png")
const FLOOR = preload("res://assets/tiles/12AdvancedFloorORWall.png")

#const BOTTOM = preload("res://assets/tiles/4TopFlatWall.png")
const WALL = preload("res://assets/tiles/1Wall.png")
#const FRONTLEFT = preload("res://assets/tiles/2LeftCurveWall.png")
#const FRONTRIGHT = preload("res://assets/tiles/2RightCurveWall.png")
#const FRONTBOTH = preload("res://assets/tiles/3BothSideCurved.png")
const LEFT = preload("res://assets/tiles/5LeftBorderWall.png")
const LEFTTOP = preload("res://assets/tiles/5LeftSideEdgeCurve.png")
const RIGHT = preload("res://assets/tiles/7RightBorderWall.png")
const RIGHTTOP = preload("res://assets/tiles/7RightSideEdgeCurve.png")
#const TOPLEFT = preload("res://assets/tiles/4LeftTopEdge.png")
#const TOPRIGHT = preload("res://assets/tiles/4TopRightEdge.png")
#const TOPWALL = preload("res://assets/tiles/8nSingleBlockCurvedWall.png")
#const TOPWALLLEFTOCCUPIED = preload("res://assets/tiles/8-nSingleBlockCurvedWall.png")
#const TOPWALLRIGHTOCCUPIED = preload("res://assets/tiles/8n-SingleBlockCurvedWall.png")
#const TOPWALLBOTHOCCUPIED = preload("res://assets/tiles/8-n-SingleBlockCurvedWall.png")
#const LEFTANDTOPOPEN = preload("res://assets/tiles/6TopLeftOpen.png")
#const RIGHTANDTOPOPEN = preload("res://assets/tiles/6TopRightOpen.png")
#const TCOPEN = preload("res://assets/tiles/6TCOpen.png")
#const TZOPEN = preload("res://assets/tiles/6TZOpen.png")
#const CENTER = preload("res://assets/tiles/9SingleBlockDoubleLineWall.png")
const CENTERTOP = preload("res://assets/tiles/9SingleBlockDoubleLineWallTop.png")
#const CENTERTOPOCCUPIEDRIGHT = preload("res://assets/tiles/9SingleBlockDoubleLineWallTopOccupiedRight.png")
#const CENTERTOPOCCUPIEDLEFT = preload("res://assets/tiles/9SingleBlockDoubleLineWallTopOccupiedLeft.png")
#const PILLAR = preload("res://assets/tiles/11Pillar.png")


@export var type: String
@export var grid_index: Dictionary

func _ready() -> void:
	var texture_to_set: Texture2D
	var sides = check_walls()
	
	match type:
		'border': # <-- done
			if 'b' in sides:
				texture_to_set = WALL
			elif 'r' in sides or ('e' in sides and 'c' in sides):
				texture_to_set = LEFT
			elif 'l' in sides or ('z' in sides and 'q' in sides):
				texture_to_set = RIGHT
			elif 't' in sides:
				texture_to_set = WALL
			elif 'c' in sides and 'z' in sides:
				texture_to_set = CENTERTOP
			elif 'c' in sides:
				texture_to_set = LEFTTOP
			elif 'z' in sides:
				texture_to_set = RIGHTTOP
			else:
				texture_to_set = BLANK_TILE
				modulate = Color8(0,0,0)
		'wall':#tblrqezc
			texture_to_set = WALL
			#if GlobalMethods.check_letters_in_string(sides, 'tblr'):
				#texture_to_set = PILLAR
			#elif GlobalMethods.check_letters_in_string(sides, 'tlr'):
				#texture_to_set = 
			#if 'b' in sides:
				#if 'r' in sides and 'c' in sides and 'l' in sides and 'z' in sides:
					#texture_to_set = CENTER
				#elif 'r' in sides and 'c' in sides:
					#texture_to_set = FRONTRIGHT
				#elif 'l' in sides and 'z' in sides:
					#texture_to_set = FRONTLEFT
				#else:
					#texture_to_set = FRONT
			#elif 'r' in sides and 'l' in sides:
				#texture_to_set = CENTER
				#if 'b' in sides and 't' in sides:
					#texture_to_set = PILLAR
				#elif 't' in sides:
					#texture_to_set = TOPWALL
			#elif 'r' in sides and 't' in sides:
				#texture_to_set = TOPWALLLEFTOCCUPIED
				##if 
			#elif 't' in sides:
				#if 'r' in sides:
					#texture_to_set = LEFT
				#elif 'l' in sides:
					#texture_to_set = RIGHT
				#elif 'l' in sides and 't' in sides:
					#texture_to_set = TOPWALLRIGHTOCCUPIED
				#else:
					#texture_to_set = BOTTOM
			#else:
				#texture_to_set = BLANK_TILE
				#modulate = Color8(0,0,0)
			#texture_to_set = [BRICK_TILE, FLOWER_TILE_REGULAR, VINES].pick_random()
			
			#if sides == 't':
				#texture_to_set = BOTTOM
			#elif sides == 'b':
				#texture_to_set = FRONT
			#elif sides == 'tb':
				#texture_to_set = FRONT
			#elif sides == 'l':
				#texture_to_set = RIGHT
			#elif sides == 'tl':
				#texture_to_set = LEFTANDTOPOPEN
			#elif sides == 'bl':
				#texture_to_set = FRONT
			#elif sides == 'tbl':
				#texture_to_set = FRONT
			#elif sides == 'r':
				#texture_to_set = LEFT
			#elif sides == 'tr':
				#texture_to_set = RIGHTANDTOPOPEN
			#elif sides == 'br':
				#texture_to_set = FRONT
			#elif sides == 'tbr':
				#texture_to_set = FRONT
			#elif sides == 'lr':
				#texture_to_set = CENTER
			#elif sides == 'tlr':
				#texture_to_set = TOPWALL
			#elif sides == 'blr':
				#texture_to_set = FRONTBOTH
			#elif sides == 'tblr':
				#texture_to_set = FRONT
			#elif sides == 'q':
				#texture_to_set = BLANK_TILE
			#elif sides == 'tq':
				#texture_to_set = BOTTOM
			#elif sides == 'bq':
				#texture_to_set = FRONT
			#elif sides == 'tbq':
				#texture_to_set = 
			#elif sides == 'lq':
				#texture_to_set = 
			#elif sides == 'tlq':
				#texture_to_set = 
			#elif sides == 'blq':
				#texture_to_set = 
			#elif sides == 'tblq':
				#texture_to_set = 
			#elif sides == 'rq':
				#texture_to_set = LEFT
			#elif sides == 'trq':
				#texture_to_set = 
			#elif sides == 'brq':
				#texture_to_set = 
			#elif sides == 'tbrq':
				#texture_to_set = 
			#elif sides == 'lrq':
				#texture_to_set = 
			#elif sides == 'tlrq':
				#texture_to_set = 
			#elif sides == 'blrq':
				#texture_to_set = 
			#elif sides == 'tblrq':
				#texture_to_set = 
			#elif sides == 'e':
				#texture_to_set = BLANK_TILE
			#elif sides == 'te':
				#texture_to_set = BOTTOM
			#elif sides == 'be':
				#texture_to_set = 
			#elif sides == 'tbe':
				#texture_to_set = 
			#elif sides == 'le':
				#texture_to_set = 
			#elif sides == 'tle':
				#texture_to_set = 
			#elif sides == 'ble':
				#texture_to_set = 
			#elif sides == 'tble':
				#texture_to_set = 
			#elif sides == 're':
				#texture_to_set = LEFT
			#elif sides == 'tre':
				#texture_to_set = 
			#elif sides == 'bre':
				#texture_to_set = 
			#elif sides == 'tbre':
				#texture_to_set = 
			#elif sides == 'lre':
				#texture_to_set = 
			#elif sides == 'tlre':
				#texture_to_set = 
			#elif sides == 'blre':
				#texture_to_set = 
			#elif sides == 'tblre':
				#texture_to_set = 
			#elif sides == 'qe':
				#texture_to_set = BLANK_TILE
			#elif sides == 'tqe':
				#texture_to_set = 
			#elif sides == 'bqe':
				#texture_to_set = 
			#elif sides == 'tbqe':
				#texture_to_set = 
			#elif sides == 'lqe':
				#texture_to_set = 
			#elif sides == 'tlqe':
				#texture_to_set = 
			#elif sides == 'blqe':
				#texture_to_set = 
			#elif sides == 'tblqe':
				#texture_to_set = 
			#elif sides == 'rqe':
				#texture_to_set = LEFT
			#elif sides == 'trqe':
				#texture_to_set = 
			#elif sides == 'brqe':
				#texture_to_set = 
			#elif sides == 'tbrqe':
				#texture_to_set = 
			#elif sides == 'lrqe':
				#texture_to_set = 
			#elif sides == 'tlrqe':
				#texture_to_set = 
			#elif sides == 'blrqe':
				#texture_to_set = 
			#elif sides == 'tblrqe':
				#texture_to_set = 
			#elif sides == 'z':
				#texture_to_set = BLANK_TILE
			#elif sides == 'tz':
				#texture_to_set = TZOPEN
			#elif sides == 'bz':
				#texture_to_set = 
			#elif sides == 'tbz':
				#texture_to_set = 
			#elif sides == 'lz':
				#texture_to_set = 
			#elif sides == 'tlz':
				#texture_to_set = 
			#elif sides == 'blz':
				#texture_to_set = 
			#elif sides == 'tblz':
				#texture_to_set = 
			#elif sides == 'rz':
				#texture_to_set = LEFT
			#elif sides == 'trz':
				#texture_to_set = 
			#elif sides == 'brz':
				#texture_to_set = 
			#elif sides == 'tbrz':
				#texture_to_set = 
			#elif sides == 'lrz':
				#texture_to_set = 
			#elif sides == 'tlrz':
				#texture_to_set = 
			#elif sides == 'blrz':
				#texture_to_set = 
			#elif sides == 'tblrz':
				#texture_to_set = 
			#elif sides == 'qz':
				#texture_to_set = BLANK_TILE
			#elif sides == 'tqz':
				#texture_to_set = TZOPEN
			#elif sides == 'bqz':
				#texture_to_set = 
			#elif sides == 'tbqz':
				#texture_to_set = 
			#elif sides == 'lqz':
				#texture_to_set = 
			#elif sides == 'tlqz':
				#texture_to_set = 
			#elif sides == 'blqz':
				#texture_to_set = 
			#elif sides == 'tblqz':
				#texture_to_set = 
			#elif sides == 'rqz':
				#texture_to_set = LEFT
			#elif sides == 'trqz':
				#texture_to_set = 
			#elif sides == 'brqz':
				#texture_to_set = 
			#elif sides == 'tbrqz':
				#texture_to_set = 
			#elif sides == 'lrqz':
				#texture_to_set = 
			#elif sides == 'tlrqz':
				#texture_to_set = 
			#elif sides == 'blrqz':
				#texture_to_set = 
			#elif sides == 'tblrqz':
				#texture_to_set = 
			#elif sides == 'ez':
				#texture_to_set = BLANK_TILE
			#elif sides == 'tez':
				#texture_to_set = TZOPEN
			#elif sides == 'bez':
				#texture_to_set = 
			#elif sides == 'tbez':
				#texture_to_set = 
			#elif sides == 'lez':
				#texture_to_set = 
			#elif sides == 'tlez':
				#texture_to_set = 
			#elif sides == 'blez':
				#texture_to_set = 
			#elif sides == 'tblez':
				#texture_to_set = 
			#elif sides == 'rez':
				#texture_to_set = LEFT
			#elif sides == 'trez':
				#texture_to_set = 
			#elif sides == 'brez':
				#texture_to_set = 
			#elif sides == 'tbrez':
				#texture_to_set = 
			#elif sides == 'lrez':
				#texture_to_set = 
			#elif sides == 'tlrez':
				#texture_to_set = 
			#elif sides == 'blrez':
				#texture_to_set = 
			#elif sides == 'tblrez':
				#texture_to_set = 
			#elif sides == 'qez':
				#texture_to_set = 
			#elif sides == 'tqez':
				#texture_to_set = 
			#elif sides == 'bqez':
				#texture_to_set = 
			#elif sides == 'tbqez':
				#texture_to_set = 
			#elif sides == 'lqez':
				#texture_to_set = 
			#elif sides == 'tlqez':
				#texture_to_set = 
			#elif sides == 'blqez':
				#texture_to_set = 
			#elif sides == 'tblqez':
				#texture_to_set = 
			#elif sides == 'rqez':
				#texture_to_set = LEFT
			#elif sides == 'trqez':
				#texture_to_set = 
			#elif sides == 'brqez':
				#texture_to_set = 
			#elif sides == 'tbrqez':
				#texture_to_set = 
			#elif sides == 'lrqez':
				#texture_to_set = 
			#elif sides == 'tlrqez':
				#texture_to_set = 
			#elif sides == 'blrqez':
				#texture_to_set = 
			#elif sides == 'tblrqez':
				#texture_to_set = 
			#elif sides == 'c':
				#texture_to_set = LEFTTOP
			#elif sides == 'tc':
				#texture_to_set = TCOPEN
			#elif sides == 'bc':
				#texture_to_set = 
			#elif sides == 'tbc':
				#texture_to_set = 
			#elif sides == 'lc':
				#texture_to_set = 
			#elif sides == 'tlc':
				#texture_to_set = 
			#elif sides == 'blc':
				#texture_to_set = 
			#elif sides == 'tblc':
				#texture_to_set = 
			#elif sides == 'rc':
				#texture_to_set = LEFT
			#elif sides == 'trc':
				#texture_to_set = 
			#elif sides == 'brc':
				#texture_to_set = 
			#elif sides == 'tbrc':
				#texture_to_set = 
			#elif sides == 'lrc':
				#texture_to_set = 
			#elif sides == 'tlrc':
				#texture_to_set = 
			#elif sides == 'blrc':
				#texture_to_set = 
			#elif sides == 'tblrc':
				#texture_to_set = 
			#elif sides == 'qc':
				#texture_to_set = BLANK_TILE
			#elif sides == 'tqc':
				#texture_to_set = TCOPEN
			#elif sides == 'bqc':
				#texture_to_set = 
			#elif sides == 'tbqc':
				#texture_to_set = 
			#elif sides == 'lqc':
				#texture_to_set = 
			#elif sides == 'tlqc':
				#texture_to_set = 
			#elif sides == 'blqc':
				#texture_to_set = 
			#elif sides == 'tblqc':
				#texture_to_set = 
			#elif sides == 'rqc':
				#texture_to_set = LEFT
			#elif sides == 'trqc':
				#texture_to_set = 
			#elif sides == 'brqc':
				#texture_to_set = 
			#elif sides == 'tbrqc':
				#texture_to_set = 
			#elif sides == 'lrqc':
				#texture_to_set = 
			#elif sides == 'tlrqc':
				#texture_to_set = 
			#elif sides == 'blrqc':
				#texture_to_set = 
			#elif sides == 'tblrqc':
				#texture_to_set = 
			#elif sides == 'ec':
				#texture_to_set = BLANK_TILE
			#elif sides == 'tec':
				#texture_to_set = TCOPEN
			#elif sides == 'bec':
				#texture_to_set = 
			#elif sides == 'tbec':
				#texture_to_set = 
			#elif sides == 'lec':
				#texture_to_set = 
			#elif sides == 'tlec':
				#texture_to_set = 
			#elif sides == 'blec':
				#texture_to_set = 
			#elif sides == 'tblec':
				#texture_to_set = 
			#elif sides == 'rec':
				#texture_to_set = LEFT
			#elif sides == 'trec':
				#texture_to_set = 
			#elif sides == 'brec':
				#texture_to_set = 
			#elif sides == 'tbrec':
				#texture_to_set = 
			#elif sides == 'lrec':
				#texture_to_set = 
			#elif sides == 'tlrec':
				#texture_to_set = 
			#elif sides == 'blrec':
				#texture_to_set = 
			#elif sides == 'tblrec':
				#texture_to_set = 
			#elif sides == 'qec':
				#texture_to_set = 
			#elif sides == 'tqec':
				#texture_to_set = 
			#elif sides == 'bqec':
				#texture_to_set = 
			#elif sides == 'tbqec':
				#texture_to_set = 
			#elif sides == 'lqec':
				#texture_to_set = 
			#elif sides == 'tlqec':
				#texture_to_set = 
			#elif sides == 'blqec':
				#texture_to_set = 
			#elif sides == 'tblqec':
				#texture_to_set = 
			#elif sides == 'rqec':
				#texture_to_set = LEFT
			#elif sides == 'trqec':
				#texture_to_set = 
			#elif sides == 'brqec':
				#texture_to_set = 
			#elif sides == 'tbrqec':
				#texture_to_set = 
			#elif sides == 'lrqec':
				#texture_to_set = 
			#elif sides == 'tlrqec':
				#texture_to_set = 
			#elif sides == 'blrqec':
				#texture_to_set = 
			#elif sides == 'tblrqec':
				#texture_to_set = 
			#elif sides == 'zc':
				#texture_to_set = BLANK_TILE
			#elif sides == 'tzc':
				#texture_to_set = 
			#elif sides == 'bzc':
				#texture_to_set = 
			#elif sides == 'tbzc':
				#texture_to_set = 
			#elif sides == 'lzc':
				#texture_to_set = 
			#elif sides == 'tlzc':
				#texture_to_set = 
			#elif sides == 'blzc':
				#texture_to_set = 
			#elif sides == 'tblzc':
				#texture_to_set = 
			#elif sides == 'rzc':
				#texture_to_set = LEFT
			#elif sides == 'trzc':
				#texture_to_set = 
			#elif sides == 'brzc':
				#texture_to_set = 
			#elif sides == 'tbrzc':
				#texture_to_set = 
			#elif sides == 'lrzc':
				#texture_to_set = 
			#elif sides == 'tlrzc':
				#texture_to_set = 
			#elif sides == 'blrzc':
				#texture_to_set = 
			#elif sides == 'tblrzc':
				#texture_to_set = 
			#elif sides == 'qzc':
				#texture_to_set = 
			#elif sides == 'tqzc':
				#texture_to_set = 
			#elif sides == 'bqzc':
				#texture_to_set = 
			#elif sides == 'tbqzc':
				#texture_to_set = 
			#elif sides == 'lqzc':
				#texture_to_set = 
			#elif sides == 'tlqzc':
				#texture_to_set = 
			#elif sides == 'blqzc':
				#texture_to_set = 
			#elif sides == 'tblqzc':
				#texture_to_set = 
			#elif sides == 'rqzc':
				#texture_to_set = LEFT
			#elif sides == 'trqzc':
				#texture_to_set = 
			#elif sides == 'brqzc':
				#texture_to_set = 
			#elif sides == 'tbrqzc':
				#texture_to_set = 
			#elif sides == 'lrqzc':
				#texture_to_set = 
			#elif sides == 'tlrqzc':
				#texture_to_set = 
			#elif sides == 'blrqzc':
				#texture_to_set = 
			#elif sides == 'tblrqzc':
				#texture_to_set = 
			#elif sides == 'ezc':
				#texture_to_set = 
			#elif sides == 'tezc':
				#texture_to_set = 
			#elif sides == 'bezc':
				#texture_to_set = 
			#elif sides == 'tbezc':
				#texture_to_set = 
			#elif sides == 'lezc':
				#texture_to_set = 
			#elif sides == 'tlezc':
				#texture_to_set = 
			#elif sides == 'blezc':
				#texture_to_set = 
			#elif sides == 'tblezc':
				#texture_to_set = 
			#elif sides == 'rezc':
				#texture_to_set = LEFT
			#elif sides == 'trezc':
				#texture_to_set = 
			#elif sides == 'brezc':
				#texture_to_set = 
			#elif sides == 'tbrezc':
				#texture_to_set = 
			#elif sides == 'lrezc':
				#texture_to_set = 
			#elif sides == 'tlrezc':
				#texture_to_set = 
			#elif sides == 'blrezc':
				#texture_to_set = 
			#elif sides == 'tblrezc':
				#texture_to_set = 
			#elif sides == 'qezc':
				#texture_to_set = 
			#elif sides == 'tqezc':
				#texture_to_set = 
			#elif sides == 'bqezc':
				#texture_to_set = 
			#elif sides == 'tbqezc':
				#texture_to_set = 
			#elif sides == 'lqezc':
				#texture_to_set = 
			#elif sides == 'tlqezc':
				#texture_to_set = 
			#elif sides == 'blqezc':
				#texture_to_set = 
			#elif sides == 'tblqezc':
				#texture_to_set = 
			#elif sides == 'rqezc':
				#texture_to_set = LEFT
			#elif sides == 'trqezc':
				#texture_to_set = 
			#elif sides == 'brqezc':
				#texture_to_set = 
			#elif sides == 'tbrqezc':
				#texture_to_set = 
			#elif sides == 'lrqezc':
				#texture_to_set = 
			#elif sides == 'tlrqezc':
				#texture_to_set = 
			#elif sides == 'blrqezc':
				#texture_to_set = 
			#elif sides == 'tblrqezc':
				#texture_to_set = 
			#else:
				#texture_to_set = WALL_PROGRAMMER_ART
		'solution':
			texture_to_set = FLOOR
		'open_cell':
			texture_to_set = FLOOR
		_: push_error("Cell has invalid type! Type: %s" % type)
	
	set_texture(texture_to_set)
	set_scale(Vector2(1,1) * GlobalVariables.MAZE_SCALE / texture.get_size())

# OLD
#func _ready() -> void:
	#var texture_to_set: Texture2D
	#var sides = check_walls()
	#
	#match type:
		#'border': # <-- done
			#if 'b' in sides:
				#texture_to_set = FRONT
			#elif 'r' in sides:
				#texture_to_set = LEFT
			#elif 'l' in sides:
				#texture_to_set = RIGHT
			#elif 't' in sides:
				#texture_to_set = FRONT
			#elif 'c' in sides and 'z' in sides:
				#texture_to_set = CENTERTOP
			#elif 'c' in sides:
				#texture_to_set = LEFTTOP
			#elif 'z' in sides:
				#texture_to_set = RIGHTTOP
			#else:
				#texture_to_set = BLANK_TILE
				#modulate = Color8(0,0,0)
		#'wall':
			#if 'b' in sides:
				#if 'r' in sides and 'c' in sides and 'l' in sides and 'z' in sides:
					#texture_to_set = CENTER
				#elif 'r' in sides and 'c' in sides:
					#texture_to_set = FRONTRIGHT
				#elif 'l' in sides and 'z' in sides:
					#texture_to_set = FRONTLEFT
				#else:
					#texture_to_set = FRONT
			#elif 'r' in sides and 'l' in sides:
				#texture_to_set = CENTER
				#if 'b' in sides and 't' in sides:
					#texture_to_set = PILLAR
				#elif 't' in sides:
					#texture_to_set = TOPWALL
			#elif 'r' in sides and 't' in sides:
				#texture_to_set = TOPWALLLEFTOCCUPIED
				##if 
			#elif 't' in sides:
				#if 'r' in sides:
					#texture_to_set = LEFT
				#elif 'l' in sides:
					#texture_to_set = RIGHT
				#elif 'l' in sides and 't' in sides:
					#texture_to_set = TOPWALLRIGHTOCCUPIED
				#else:
					#texture_to_set = BOTTOM
			#else:
				#texture_to_set = BLANK_TILE
				#modulate = Color8(0,0,0)
			##texture_to_set = [BRICK_TILE, FLOWER_TILE_REGULAR, VINES].pick_random()
		#'solution':
			#texture_to_set = BLANK_TILE#ROUGH_TILE
		#'open_cell':
			#texture_to_set = BLANK_TILE#ROUGH_TILE
		#_: push_error("Cell has invalid type! Type: %s" % type)
	#
	#set_texture(texture_to_set)
	#set_scale(Vector2(1,1) * GlobalVariables.MAZE_SCALE / texture.get_size())

func check_sanity(x, y) -> bool:
	return (x in range(0, GlobalVariables.MAZE_X)) and (y in range(0, GlobalVariables.MAZE_Y))

# q: tl
# e: tr
# z: bl
# c: br
func check_walls() -> String:
	var string: String = ""
	string += 't' if check_sanity(grid_index.x, grid_index.y-1) and not GlobalVariables.replicated_grid[grid_index.y-1][grid_index.x].wall else ""
	string += 'b' if check_sanity(grid_index.x, grid_index.y+1) and not GlobalVariables.replicated_grid[grid_index.y+1][grid_index.x].wall else ""
	string += 'l' if check_sanity(grid_index.x-1, grid_index.y) and not GlobalVariables.replicated_grid[grid_index.y][grid_index.x-1].wall else ""
	string += 'r' if check_sanity(grid_index.x+1, grid_index.y) and not GlobalVariables.replicated_grid[grid_index.y][grid_index.x+1].wall else ""
	string += 'q' if check_sanity(grid_index.x-1, grid_index.y-1) and not GlobalVariables.replicated_grid[grid_index.y-1][grid_index.x-1].wall else ""
	string += 'e' if check_sanity(grid_index.x+1, grid_index.y-1) and not GlobalVariables.replicated_grid[grid_index.y-1][grid_index.x+1].wall else ""
	string += 'z' if check_sanity(grid_index.x-1, grid_index.y+1) and not GlobalVariables.replicated_grid[grid_index.y+1][grid_index.x-1].wall else ""
	string += 'c' if check_sanity(grid_index.x+1, grid_index.y+1) and not GlobalVariables.replicated_grid[grid_index.y+1][grid_index.x+1].wall else ""
	#if len(string) != 8: print(string)
	return string

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
