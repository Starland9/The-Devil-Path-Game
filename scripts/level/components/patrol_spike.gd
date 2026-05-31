extends Node2D
class_name PatrolSpike

# TROLL — Level 27: Moving Death
# Spikes patrol back and forth horizontally.

@export var patrol_range: float = 200.0
@export var speed: float        = 140.0

@onready var visual: ColorRect = $Visual
@onready var kill_area: Area2D = $KillArea

var _origin: Vector2
var _dir: float = 1.0

func _ready() -> void:
	_origin = global_position
	kill_area.body_entered.connect(_on_kill_area_entered)

func _process(delta: float) -> void:
	global_position.x += _dir * speed * delta
	if abs(global_position.x - _origin.x) >= patrol_range:
		_dir = -_dir

func _on_kill_area_entered(body: Node) -> void:
	if body.has_method("kill"):
		body.kill()

func _troll_reset() -> void:
	global_position = _origin
	_dir = 1.0
