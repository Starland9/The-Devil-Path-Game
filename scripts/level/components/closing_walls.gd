extends Node2D
class_name ClosingWalls

# TROLL — Level 20: Panic Room
# Two walls close in from the sides.

@export var close_speed: float = 28.0
@export var kill_gap: float    = 60.0

@onready var left_wall: StaticBody2D  = $LeftWall
@onready var right_wall: StaticBody2D = $RightWall

var _player: Node  = null
var _left_origin: float  = 0.0
var _right_origin: float = 0.0

func _ready() -> void:
	_left_origin  = left_wall.position.x
	_right_origin = right_wall.position.x

func _process(delta: float) -> void:
	if _player == null:
		var players: Array[Node] = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			_player = players[0]

	left_wall.position.x  += close_speed * delta
	right_wall.position.x -= close_speed * delta

	var gap: float = right_wall.position.x - left_wall.position.x
	if gap < kill_gap and _player != null and _player.has_method("kill"):
		_player.kill()

func _troll_reset() -> void:
	left_wall.position.x  = _left_origin
	right_wall.position.x = _right_origin
	_player = null
