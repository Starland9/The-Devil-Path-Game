extends Node2D
class_name LevelBase

@export var level_id: int = 1
@export var next_level_scene: String = ""
## Override in derived levels to apply mobile hitbox expansion
@export var has_precision_platforms: bool = false

@onready var spawn_point: Marker2D    = $SpawnPoint
@onready var exit_area: Area2D        = $Exit
@onready var death_zone: Area2D       = $DeathZone
@onready var hud_layer: CanvasLayer   = $HUD

var _gs: Node
var _player: CharacterBody2D
var _death_count: int = 0
var _timer: float = 0.0
var _active: bool = true

signal level_completed(level_id: int, deaths: int, time: float)

func _ready() -> void:
	_gs = get_node("/root/GameState")
	_apply_mobile_hitboxes()
	_spawn_player()
	exit_area.body_entered.connect(_on_exit_entered)
	death_zone.body_entered.connect(_on_death_zone_entered)
	_hud_call("set_level_name", "LEVEL %02d" % level_id)
	_hud_call("update_deaths", _death_count)

func _process(delta: float) -> void:
	if _active:
		_timer += delta
		_hud_call("update_timer", _timer)

func _spawn_player() -> void:
	var scene := load("res://scenes/player.tscn") as PackedScene
	_player = scene.instantiate() as CharacterBody2D
	_player.global_position = spawn_point.global_position
	_player.died.connect(_on_player_died)
	_player.add_to_group("player")
	add_child(_player)

func _on_player_died() -> void:
	if not _active:
		return
	_death_count += 1
	var sfx := get_node_or_null("/root/SFX")
	if sfx:
		sfx.play("death")
	_hud_call("update_deaths", _death_count)
	_hud_call("flash_death")
	await get_tree().create_timer(0.05).timeout
	_reset_troll_components()
	_player.respawn(spawn_point.global_position)

func _reset_troll_components() -> void:
	for child in get_children():
		if child.has_method("_troll_reset"):
			child._troll_reset()

func _on_exit_entered(body: Node) -> void:
	if body == _player and _active:
		_active = false
		_gs.save_level_result(level_id, _death_count, _timer)
		_unlock_ability_if_needed()
		var sfx := get_node_or_null("/root/SFX")
		if sfx:
			sfx.play("win")
		emit_signal("level_completed", level_id, _death_count, _timer)
		await get_tree().create_timer(0.6).timeout
		_go_to_next()

func _on_death_zone_entered(body: Node) -> void:
	if body == _player:
		_player.kill()

func _go_to_next() -> void:
	if next_level_scene != "":
		get_tree().change_scene_to_file(next_level_scene)
	else:
		# Auto-derive next level path
		var next_id := level_id + 1
		var path := "res://scenes/levels/level_%02d.tscn" % next_id
		if ResourceLoader.exists(path):
			get_tree().change_scene_to_file(path)
		else:
			get_tree().change_scene_to_file("res://scenes/hub.tscn")

func _unlock_ability_if_needed() -> void:
	# Abilities unlocked upon completing specific levels
	var unlocks := {
		7:  "double_jump",
		15: "dash",
		29: "sprint",
		49: "wall_jump",
		74: "charged_jump"
	}
	if level_id in unlocks:
		_gs.unlock_ability(unlocks[level_id])

func _apply_mobile_hitboxes() -> void:
	if not has_precision_platforms:
		return
	if OS.get_name() not in ["Android", "iOS"]:
		return
	# Expand RectangleShape2D on StaticBody2D children by MOBILE_HB_EXPAND px per side
	_expand_shapes_recursive(self)

func _expand_shapes_recursive(node: Node) -> void:
	for child in node.get_children():
		if child is CollisionShape2D:
			var shape: Shape2D = (child as CollisionShape2D).shape
			if shape is RectangleShape2D:
				(shape as RectangleShape2D).size.x += 16.0  # +8 each side
		_expand_shapes_recursive(child)

# Utility: call a method on the HUD CanvasLayer (script lives on the node itself)
func _hud_call(method: String, arg = null) -> void:
	if hud_layer == null:
		return
	if not hud_layer.has_method(method):
		return
	if arg != null:
		hud_layer.call(method, arg)
	else:
		hud_layer.call(method)
