extends Area2D
class_name TrollCoin

# TROLL — Level 21: The Troll Coin
# Collecting the coin restarts the level.

@onready var visual: ColorRect = $Visual

var _collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if _collected or body is not CharacterBody2D:
		return
	_collected = true
	visual.visible = false
	var sfx := get_node_or_null("/root/SFX")
	if sfx:
		sfx.play("collect")
	await get_tree().create_timer(0.25).timeout
	get_tree().reload_current_scene()

func _troll_reset() -> void:
	_collected = false
	visual.visible = true
