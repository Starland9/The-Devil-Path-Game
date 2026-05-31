extends Area2D
class_name MovingExit

# TROLL — Level 3: Welcome Trap
# Exit teleports to the opposite side of the map when player gets close.

@export var trigger_distance: float = 200.0
@export var teleport_offset: Vector2 = Vector2(900.0, 0.0)

var _teleported: bool = false
var _origin: Vector2

@onready var visual: ColorRect = $Visual

func _ready() -> void:
	_origin = global_position

func _process(_delta: float) -> void:
	if _teleported:
		return
	var player := _find_player()
	if player == null:
		return
	if global_position.distance_to(player.global_position) < trigger_distance:
		_troll_activate()

func _troll_activate() -> void:
	if _teleported:
		return
	_teleported = true
	# Flash then teleport
	var tween := create_tween()
	tween.tween_property(visual, "modulate:a", 0.0, 0.1)
	tween.tween_callback(_do_teleport)
	tween.tween_property(visual, "modulate:a", 1.0, 0.1)

func _do_teleport() -> void:
	# Move to opposite side
	global_position = _origin - teleport_offset if global_position.x > 640.0 else _origin + teleport_offset

func _troll_reset() -> void:
	_teleported = false
	global_position = _origin
	visual.modulate.a = 1.0

func _find_player() -> Node:
	var tree := get_tree()
	if tree == null:
		return null
	var players := tree.get_nodes_in_group("player")
	return players[0] if players.size() > 0 else null
