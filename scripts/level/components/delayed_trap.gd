extends Node2D
class_name DelayedTrap

# TROLL — Level 22: Delayed Trap
# 5 seconds after the player enters the trigger zone, they are killed.
# A warning flashes with increasing intensity.

@export var delay: float = 5.0

@onready var trigger: Area2D    = $TriggerArea
@onready var warning: ColorRect = $Warning

var _player: Node  = null
var _timer: float  = 0.0
var _active: bool  = false

func _ready() -> void:
	warning.modulate.a = 0.15
	trigger.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if _active or body is not CharacterBody2D:
		return
	_active = true
	_timer  = delay
	_player = body

func _process(delta: float) -> void:
	if not _active:
		return
	_timer -= delta
	var t: float = 1.0 - clampf(_timer / delay, 0.0, 1.0)
	if _timer < 1.5:
		warning.modulate.a = lerp(0.5, 1.0, t)
		warning.visible = int(_timer * 8.0) % 2 == 0
	else:
		warning.modulate.a = lerp(0.15, 0.55, t)
	if _timer <= 0.0:
		_active = false
		if is_instance_valid(_player) and _player.has_method("kill"):
			_player.kill()

func _troll_reset() -> void:
	_active = false
	_timer  = 0.0
	_player = null
	warning.modulate.a = 0.15
	warning.visible = true
