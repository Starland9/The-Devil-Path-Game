extends Node2D
class_name HiddenKey

# TROLL — Level 10: First Rage
# Exit requires a second hidden key the player doesn't know about.
# Key is hidden behind a wall / in a non-obvious spot.
# When collected, it unlocks the exit Area2D.

signal key_collected

@export var exit_node_path: NodePath = NodePath("")

@onready var key_area: Area2D   = $KeyArea
@onready var key_visual: ColorRect = $KeyArea/Visual
@onready var lock_visual: ColorRect = $LockVisual   # red overlay on exit

var _has_key: bool = false

func _ready() -> void:
	key_area.body_entered.connect(_on_key_picked)
	# Start locked
	_update_lock_state()

func _on_key_picked(body: Node) -> void:
	if _has_key or body is not CharacterBody2D:
		return
	_has_key = true
	key_visual.visible = false
	var sfx := get_node_or_null("/root/SFX")
	if sfx:
		sfx.play("collect")
	emit_signal("key_collected")
	_update_lock_state()

func _update_lock_state() -> void:
	if lock_visual:
		lock_visual.visible = not _has_key
	# Disable / enable exit collision
	if exit_node_path != NodePath(""):
		var exit := get_node_or_null(exit_node_path)
		if exit:
			for child in exit.get_children():
				if child is CollisionShape2D:
					(child as CollisionShape2D).set_deferred("disabled", not _has_key)


func is_key_collected() -> bool:
	return _has_key

func _troll_reset() -> void:
	_has_key = false
	key_visual.visible = true
	_update_lock_state()
