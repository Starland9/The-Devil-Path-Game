extends Node
class_name RandomGravity

# TROLL — Level 26: Hidden Gravity
# Gravity multiplier changes randomly every few seconds.

@export var change_interval: float = 3.0

const GRAVITY_VALUES: Array[float] = [-1.0, 0.5, 1.5, 2.0, 1.0, -0.8]

var _player: Node  = null
var _timer: float  = 0.0

func _process(delta: float) -> void:
	if _player == null:
		var players: Array[Node] = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			_player = players[0]
		return

	_timer -= delta
	if _timer <= 0.0:
		_timer = change_interval + randf_range(-0.5, 0.8)
		_apply_random()

func _apply_random() -> void:
	if "gravity_multiplier" in _player:
		_player.gravity_multiplier = GRAVITY_VALUES[randi() % GRAVITY_VALUES.size()]

func _troll_reset() -> void:
	_timer = 0.0
	if _player != null and "gravity_multiplier" in _player:
		_player.gravity_multiplier = 1.0
	_player = null
