extends Node
class_name JumpPunisher

# TROLL — Level 23: Jump Punisher
# Every 3rd jump press kills the player instantly.

@export var max_jumps: int = 3

var _player: Node    = null
var _jump_count: int = 0

func _process(_delta: float) -> void:
	if _player == null:
		var players: Array[Node] = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			_player = players[0]
		return

	if Input.is_action_just_pressed("jump"):
		_jump_count += 1
		if _jump_count >= max_jumps:
			_jump_count = 0
			if _player.has_method("kill"):
				_player.kill()

func _troll_reset() -> void:
	_jump_count = 0
	_player = null
