extends Node2D
class_name VanishingLadder

# TROLL — Level 28: Vanishing Ladder
# Platforms disappear one by one from bottom to top after start_delay seconds.

@export var start_delay: float = 3.5
@export var step_delay:  float = 0.5

var _platforms: Array[Node] = []
var _timer: float           = 0.0
var _index: int             = 0

func _ready() -> void:
	for child in get_children():
		if child is StaticBody2D:
			_platforms.append(child)
	# Sort bottom-to-top (largest Y = bottom rung, disappears first)
	_platforms.sort_custom(func(a: Node, b: Node) -> bool:
		return a.position.y > b.position.y
	)
	_timer = start_delay

func _process(delta: float) -> void:
	if _index >= _platforms.size():
		return
	_timer -= delta
	if _timer <= 0.0:
		_vanish_next()
		_timer = step_delay

func _vanish_next() -> void:
	var plat: Node = _platforms[_index]
	_index += 1
	var col: CollisionShape2D = plat.get_node_or_null("CollisionShape2D")
	if col:
		col.disabled = true
	var vis: ColorRect = plat.get_node_or_null("Visual")
	if vis:
		var tw := create_tween()
		tw.tween_property(vis, "modulate:a", 0.0, 0.3)

func _troll_reset() -> void:
	_timer = start_delay
	_index = 0
	for plat in _platforms:
		var col: CollisionShape2D = plat.get_node_or_null("CollisionShape2D")
		if col:
			col.disabled = false
		var vis: ColorRect = plat.get_node_or_null("Visual")
		if vis:
			vis.modulate.a = 1.0
