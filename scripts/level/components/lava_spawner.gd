extends Node
class_name LavaSpawner

# TROLL — Level 24: Floor Is Lava
# Standing still for too long spawns a lava block that kills on contact.

@export var idle_time: float = 0.3
 
var _player: Node             = null
var _idle_timer: float        = 0.0
var _last_pos: Vector2        = Vector2.ZERO
var _lava_blocks: Array[Node] = []

func _process(delta: float) -> void:
	if _player == null:
		var players: Array[Node] = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			_player = players[0]
			_last_pos = _player.global_position
		return

	var cur: Vector2 = _player.global_position
	if cur.distance_to(_last_pos) < 5.0:
		_idle_timer += delta
		if _idle_timer >= idle_time:
			_idle_timer = 0.0
			_spawn_lava(cur)
	else:
		_idle_timer = 0.0
	_last_pos = cur

func _spawn_lava(pos: Vector2) -> void:
	var lava := Area2D.new()
	var shape_node := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(80, 24)
	shape_node.shape = shape
	var vis := ColorRect.new()
	vis.size = Vector2(80, 24)
	vis.position = Vector2(-40.0, -12.0)
	vis.color = Color(0.95, 0.35, 0.05, 1)
	lava.add_child(shape_node)
	lava.add_child(vis)
	lava.global_position = pos + Vector2(0.0, 24.0)
	lava.body_entered.connect(func(body: Node) -> void:
		if body.has_method("kill"):
			body.kill()
	)
	get_tree().current_scene.add_child(lava)
	_lava_blocks.append(lava)

func _troll_reset() -> void:
	_idle_timer = 0.0
	_player     = null
	for b in _lava_blocks:
		if is_instance_valid(b):
			b.queue_free()
	_lava_blocks.clear()
