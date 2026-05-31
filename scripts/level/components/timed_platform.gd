extends StaticBody2D
class_name TimedPlatform

# TROLL — Level 16: Tiny Window
# Appears for a short window, then disappears again.

@export var visible_duration: float = 1.0
@export var hidden_duration: float  = 4.0

@onready var col: CollisionShape2D = $CollisionShape2D
@onready var visual: ColorRect     = $Visual

var _showing: bool  = false
var _timer: float   = 0.0

func _ready() -> void:
	col.disabled = true
	visual.modulate.a = 0.0
	_timer = hidden_duration

func _process(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		if _showing:
			_hide()
		else:
			_show()

func _show() -> void:
	_showing = true
	_timer = visible_duration
	col.disabled = false
	var tw := create_tween()
	tw.tween_property(visual, "modulate:a", 1.0, 0.12)

func _hide() -> void:
	_showing = false
	_timer = hidden_duration
	col.disabled = true
	var tw := create_tween()
	tw.tween_property(visual, "modulate:a", 0.0, 0.12)

func _troll_reset() -> void:
	_showing = false
	_timer = hidden_duration
	col.disabled = true
	visual.modulate.a = 0.0
