extends Area2D
class_name FakeCollectible

# TROLL — Level 9: Fake Coin
# Collecting the coin activates spikes everywhere.

@onready var coin_visual: ColorRect  = $CoinVisual
@onready var spikes: Node2D          = $Spikes

var _collected: bool = false

func _ready() -> void:
	spikes.visible = false
	body_entered.connect(_on_body_entered)
	# Wire spike areas
	for child in spikes.get_children():
		if child is Area2D:
			(child as Area2D).body_entered.connect(_on_spike_hit)

func _on_body_entered(body: Node) -> void:
	if _collected or body is not CharacterBody2D:
		return
	_collected = true
	coin_visual.visible = false
	var sfx := get_node_or_null("/root/SFX")
	if sfx:
		sfx.play("collect")
	# Short delay then BOOM
	get_tree().create_timer(0.15).timeout.connect(_troll_activate)

func _troll_activate() -> void:
	spikes.visible = true

func _on_spike_hit(body: Node) -> void:
	if body is CharacterBody2D:
		body.kill()

func _troll_reset() -> void:
	_collected = false
	coin_visual.visible = true
	spikes.visible = false
