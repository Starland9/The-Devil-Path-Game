extends StaticBody2D
class_name DisappearingPlatform

# TROLL — Level 2: Trust Issues
# Disappears on first touch, never comes back until respawn.

@export var fade_time: float = 0.18

@onready var visual: ColorRect      = $Visual
@onready var col: CollisionShape2D  = $CollisionShape2D

var _touched: bool = false

func _ready() -> void:
	var area := $TriggerArea as Area2D
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if _touched or body is not CharacterBody2D:
		return
	_touched = true
	var tween := create_tween()
	tween.tween_property(visual, "modulate:a", 0.0, fade_time)
	tween.tween_callback(_disable_collision)

func _disable_collision() -> void:
	col.disabled = true

func _troll_reset() -> void:
	_touched = false
	col.disabled = false
	visual.modulate.a = 1.0
