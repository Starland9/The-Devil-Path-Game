extends Node

const SAVE_PATH := "user://save.cfg"

var current_level: int = 1
var deaths_per_level: Dictionary = {}
var completed_levels: Array[int] = []
var best_times: Dictionary = {}
var unlocked_abilities: Array[String] = ["jump"]

func _ready() -> void:
	load_save()

func unlock_ability(ability: String) -> void:
	if ability not in unlocked_abilities:
		unlocked_abilities.append(ability)
		save_game()

func has_ability(ability: String) -> bool:
	return ability in unlocked_abilities

func save_level_result(level_id: int, deaths: int, time: float) -> void:
	var key := str(level_id)
	if level_id not in completed_levels:
		completed_levels.append(level_id)
	deaths_per_level[key] = deaths
	if not best_times.has(key) or time < best_times[key]:
		best_times[key] = time
	save_game()

func get_level_result(level_id: int) -> Dictionary:
	var key := str(level_id)
	return {
		"completed": level_id in completed_levels,
		"deaths": deaths_per_level.get(key, 0),
		"best_time": best_times.get(key, 0.0)
	}

func is_level_unlocked(level_id: int) -> bool:
	if level_id == 1:
		return true
	return (level_id - 1) in completed_levels

func save_game() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("progress", "current_level", current_level)
	cfg.set_value("progress", "completed_levels", completed_levels)
	cfg.set_value("progress", "deaths_per_level", deaths_per_level)
	cfg.set_value("progress", "best_times", best_times)
	cfg.set_value("progress", "unlocked_abilities", unlocked_abilities)
	cfg.save(SAVE_PATH)

func load_save() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) != OK:
		return
	current_level = cfg.get_value("progress", "current_level", 1)
	completed_levels = cfg.get_value("progress", "completed_levels", [])
	deaths_per_level = cfg.get_value("progress", "deaths_per_level", {})
	best_times = cfg.get_value("progress", "best_times", {})
	unlocked_abilities = cfg.get_value("progress", "unlocked_abilities", ["jump"])

func reset_save() -> void:
	current_level = 1
	deaths_per_level = {}
	completed_levels = []
	best_times = {}
	unlocked_abilities = ["jump"]
	save_game()
