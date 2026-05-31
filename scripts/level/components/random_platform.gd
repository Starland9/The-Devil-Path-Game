extends StaticBody2D
class_name RandomPlatform

# TROLL — Level 13: Platform Roulette
# Has a random chance to be absent at the start of each attempt.

@export var vanish_chance: float = 0.4

@onready var col: CollisionShape2D = $CollisionShape2D
@onready var visual: ColorRect     = $Visual

func _ready() -> void:
	_roll()

func _roll() -> void:
	if randf() < vanish_chance:
		col.disabled = true
		visual.modulate.a = 0.0

func _troll_reset() -> void:
	col.disabled = false
	visual.modulate.a = 1.0
	_roll()
