extends StaticBody2D
class_name CollapsingFloor

# TROLL — Level 4: False Floor
# Floor collapses only under the player's feet — tiles directly below player fall.

@export var collapse_delay: float = 0.05   # seconds after contact before dropping
@export var fall_speed: float     = 600.0

@onready var col: CollisionShape2D = $CollisionShape2D
@onready var visual: ColorRect     = $Visual

var _collapsing: bool = false
var _origin_y: float  = 0.0
var _origin_disabled : bool

func _ready() -> void:
	fall_speed = randf_range(200, 600)
	_origin_y = position.y
	_origin_disabled = col.disabled
	var area := $TriggerArea as Area2D
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if _collapsing or body is not CharacterBody2D:
		return
	_collapsing = true
	get_tree().create_timer(collapse_delay).timeout.connect(_start_fall)

func _start_fall() -> void:
	col.disabled = true

func _process(delta: float) -> void:
	if _collapsing and col.disabled:
		position.y += fall_speed * delta
		visual.modulate.a = max(0.0, visual.modulate.a - delta * 3.0)

func _troll_reset() -> void:
	_collapsing = false
	col.disabled = _origin_disabled
	position.y = _origin_y
	visual.modulate.a = 1.0
