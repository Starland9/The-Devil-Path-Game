extends Node2D
class_name FallingCeilingSpike

# TROLL — Level 11: The Ceiling Hates You
# Falls when the player runs underneath at speed.

@export var trigger_speed: float = 160.0
@export var fall_speed: float    = 580.0
@export var warning_time: float  = 0.35

@onready var visual: ColorRect = $Visual
@onready var kill_area: Area2D = $KillArea

var _state: int = 0  # 0=idle  1=warning  2=falling  3=dead
var _timer: float = 0.0
var _origin: Vector2

func _ready() -> void:
	_origin = position
	kill_area.body_entered.connect(_on_kill_area_entered)

func _process(delta: float) -> void:
	match _state:
		0:
			var player: CharacterBody2D = _find_player()
			if player == null:
				return
			var py: float = player.global_position.y
			var px: float = player.global_position.x
			if py > global_position.y and abs(px - global_position.x) < 80.0:
				var spd: float = abs(player.velocity.x)
				if spd >= trigger_speed:
					_state = 1
					_timer = warning_time
		1:
			_timer -= delta
			visual.visible = int(_timer * 12.0) % 2 == 0
			if _timer <= 0.0:
				_state = 2
				visual.visible = true
		2:
			position.y += fall_speed * delta
			if position.y > 820.0:
				_die()
		3:
			pass

func _on_kill_area_entered(body: Node) -> void:
	if body.has_method("kill"):
		body.kill()
	_die()

func _die() -> void:
	_state = 3
	visible = false

func _troll_reset() -> void:
	_state = 0
	position = _origin
	visible = true
	visual.visible = true

func _find_player() -> CharacterBody2D:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		return players[0] as CharacterBody2D
	return null
