extends CharacterBody2D
class_name ChaserEnemy

# TROLL — Level 17: The Chase
# Follows the player relentlessly. Indestructible.

@export var speed: float   = 155.0
@export var gravity: float = 1400.0

@onready var visual: ColorRect = $Visual
@onready var kill_area: Area2D = $KillArea

var _player: Node  = null
var _origin: Vector2

func _ready() -> void:
	_origin = global_position
	kill_area.body_entered.connect(_on_kill_area_entered)

func _physics_process(delta: float) -> void:
	if _player == null:
		var players: Array[Node] = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			_player = players[0]

	if not is_on_floor():
		velocity.y += gravity * delta

	if _player != null:
		var dir: float = sign(_player.global_position.x - global_position.x)
		velocity.x = dir * speed

	move_and_slide()

func _on_kill_area_entered(body: Node) -> void:
	if body.has_method("kill"):
		body.kill()

func _troll_reset() -> void:
	global_position = _origin
	velocity = Vector2.ZERO
	_player = null
