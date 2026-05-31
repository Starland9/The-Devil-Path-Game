extends Node2D
class_name RisingLava

# TROLL — Level 12: Slow Death
# Lava rises from below and kills on contact.

@export var rise_speed: float = 45.0

@onready var visual: ColorRect = $Visual
@onready var kill_area: Area2D = $KillArea

var _origin_y: float = 0.0

func _ready() -> void:
	_origin_y = position.y
	kill_area.body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position.y -= rise_speed * delta

func _on_body_entered(body: Node) -> void:
	if body.has_method("kill"):
		body.kill()

func _troll_reset() -> void:
	position.y = _origin_y
