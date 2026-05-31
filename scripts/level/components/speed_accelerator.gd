extends Node
class_name SpeedAccelerator

# TROLL — Level 29: Speed Demon
# Player's extra_speed continuously increases — can't slow down.

@export var acceleration: float = 20.0
@export var max_bonus: float    = 380.0

var _player: Node = null

func _process(delta: float) -> void:
	if _player == null:
		var players: Array[Node] = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			_player = players[0]
		return
	if "extra_speed" in _player:
		_player.extra_speed = minf(_player.extra_speed + acceleration * delta, max_bonus)

func _troll_reset() -> void:
	if _player != null and "extra_speed" in _player:
		_player.extra_speed = 0.0
	_player = null
