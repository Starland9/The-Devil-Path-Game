extends Area2D
class_name ExitSpikeTrap

# TROLL — Level 6: Confidence Punished
# Fake exit: flashes red then kills the player immediately.
# The real $Exit is hidden elsewhere in the level.

@onready var visual: ColorRect = $Visual

var _triggered: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if _triggered or body is not CharacterBody2D:
		return
	_triggered = true
	var tween := create_tween()
	tween.tween_property(visual, "modulate", Color(1, 0, 0, 1), 0.06)
	tween.tween_property(visual, "modulate", Color(1, 0.1, 0.1, 1), 0.08)
	tween.tween_callback(func(): body.kill())

func _troll_reset() -> void:
	_triggered = false
	visual.modulate = Color.WHITE
