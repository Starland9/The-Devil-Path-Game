extends Node
class_name ControlReverser

# TROLL — Level 14: Mirror World
# Reverses the player's horizontal input.

var _player: Node = null
var _activated: bool = false

func _process(_delta: float) -> void:
	if _activated:
		return
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.size() == 0:
		return
	_player = players[0]
	if "input_reversed" in _player:
		_player.input_reversed = true
	_activated = true

func _troll_reset() -> void:
	_activated = false
	if _player != null and "input_reversed" in _player:
		_player.input_reversed = false
	_player = null
