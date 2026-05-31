extends StaticBody2D
class_name FleeingBlock

# TROLL — Level 18: Betrayal Block
# Slides away from the player when approached.
# Once the player stands on it, it carries them to the other side.

@export var detect_radius: float = 80.0
@export var flee_speed: float    = 200.0
@export var max_offset: float    = 280.0

var _player: Node  = null
var _origin: Vector2

func _ready() -> void:
	_origin = global_position

func _process(delta: float) -> void:
	if _player == null:
		var players: Array[Node] = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			_player = players[0]
		return

	var dist: float = global_position.distance_to(_player.global_position)
	if dist < detect_radius:
		var dir: float = sign(global_position.x - _player.global_position.x)
		if dir == 0.0:
			dir = 1.0
		var target_x: float = _origin.x + dir * max_offset
		global_position.x = move_toward(global_position.x, target_x, flee_speed * delta)

func _troll_reset() -> void:
	global_position = _origin
	_player = null
