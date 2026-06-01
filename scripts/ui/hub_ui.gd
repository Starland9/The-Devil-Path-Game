extends Node

@onready var grid: GridContainer = $Root/Scroll/Grid
@onready var back_btn: Button    = $Root/BackButton
@onready var title_lbl: Label    = $Root/TitleLabel
@onready var scroll: ScrollContainer = $Root/Scroll

const TOTAL_LEVELS := 100

var _gs: Node

func _ready() -> void:
	_gs = get_node("/root/GameState")
	back_btn.pressed.connect(_on_back)
	_resize_grid()
	_populate()
	
	
func _resize_grid():
	var w := scroll.size.x
	grid.columns = int(w / (64 + grid.get_theme_constant("h_separation")))

func _populate() -> void:
	for child in grid.get_children():
		child.queue_free()

	for i in range(1, TOTAL_LEVELS + 1):
		var btn := Button.new()
		var result: Dictionary = _gs.get_level_result(i)
		var unlocked: bool = _gs.is_level_unlocked(i)

		btn.text = "%d" % i
		btn.custom_minimum_size = Vector2(64, 64)
		btn.tooltip_text = ""

		if not unlocked:
			btn.disabled = true
			btn.modulate = Color(0.35, 0.35, 0.35, 1.0)
		elif result["completed"]:
			if result["deaths"] == 0:
				btn.modulate = Color(1.0, 0.85, 0.0, 1.0)   # gold = perfect
				btn.tooltip_text = "PERFECT"
			else:
				btn.modulate = Color(0.85, 0.12, 0.12, 1.0) # red = completed
				btn.tooltip_text = "Deaths: %d" % result["deaths"]

		btn.pressed.connect(_on_level_btn.bind(i))
		grid.add_child(btn)

	# Focus first unlocked level
	for child in grid.get_children():
		if child is Button and not child.disabled:
			child.grab_focus()
			break

func _on_level_btn(level_id: int) -> void:
	var path := "res://scenes/levels/level_%02d.tscn" % level_id
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)

func _on_back() -> void:
	get_tree().change_scene_to_file("res://scenes/intro.tscn")
