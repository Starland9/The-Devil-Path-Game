extends Node2D
class_name GravityInverter

# TROLL — Level 7: Reverse Jump
# Jumping inverts gravity on the player for 2 seconds.
# Also the level that unlocks double_jump (handled by LevelBase).

@export var invert_duration: float = 2.0

var _player: Node = null
var _timer: float = 0.0
var _active: bool = false
  
func _ready() -> void:  
	# Watch for jump input — hook into process
	pass

func _process(delta: float) -> void:
	if _player == null:
		_player = _find_player()
		return

	# Detect jump just pressed
	if Input.is_action_just_pressed("jump") and not _player.is_on_floor():
		_troll_activate()

	if _active:
		_timer -= delta
		if _timer <= 0.0:
			_deactivate()

func _troll_activate() -> void:
	if _active:
		return
	_active = true 
	_timer = invert_duration
	if _player.has_method("set") and "gravity_multiplier" in _player:
		_player.gravity_multiplier = -1.0

func _deactivate() -> void:
	_active = false
	if _player != null and "gravity_multiplier" in _player:
		_player.gravity_multiplier = 1.0

func _troll_reset() -> void:
	_active = false
	_timer = 0.0
	if _player != null and "gravity_multiplier" in _player:
		_player.gravity_multiplier = 1.0

func _find_player() -> Node:
	var players := get_tree().get_nodes_in_group("player")
	return players[0] if players.size() > 0 else null
