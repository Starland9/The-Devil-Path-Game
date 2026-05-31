extends Node2D
class_name WideningPit

# TROLL MECHANIC — Level 1: The Lie
# The pit quietly widens while the player is airborne above it.
# Interface: _troll_activate() / _troll_reset()

@export var widen_amount: float = 96.0   # pixels each wall moves outward
@export var widen_speed: float  = 180.0  # px/sec

@onready var left_wall:    StaticBody2D = $LeftWall
@onready var right_wall:   StaticBody2D = $RightWall
@onready var trigger_zone: Area2D       = $TriggerZone

var _orig_left_x:  float = 0.0
var _orig_right_x: float = 0.0
var _target_left_x:  float = 0.0
var _target_right_x: float = 0.0
var _widening: bool = false

func _ready() -> void:
	_orig_left_x   = left_wall.position.x
	_orig_right_x  = right_wall.position.x
	_target_left_x  = _orig_left_x
	_target_right_x = _orig_right_x
	trigger_zone.body_entered.connect(_on_trigger_entered)

func _process(delta: float) -> void:
	if not _widening:
		return
	left_wall.position.x  = move_toward(left_wall.position.x,  _target_left_x,  widen_speed * delta)
	right_wall.position.x = move_toward(right_wall.position.x, _target_right_x, widen_speed * delta)

func _on_trigger_entered(body: Node) -> void:
	if body is CharacterBody2D and not body.is_on_floor():
		_troll_activate()

func _troll_activate() -> void:
	if _widening:
		return
	_widening = true
	_target_left_x  = _orig_left_x  - widen_amount
	_target_right_x = _orig_right_x + widen_amount

func _troll_reset() -> void:
	_widening = false
	left_wall.position.x   = _orig_left_x
	right_wall.position.x  = _orig_right_x
	_target_left_x  = _orig_left_x
	_target_right_x = _orig_right_x
