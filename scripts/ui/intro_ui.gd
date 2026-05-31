extends Node

@onready var play_btn:     Button = $Root/Center/VBox/PlayButton
@onready var settings_btn: Button = $Root/Center/VBox/SettingsButton
@onready var quit_btn:     Button = $Root/Center/VBox/QuitButton

func _ready() -> void:
	play_btn.pressed.connect(_on_play)
	settings_btn.pressed.connect(_on_settings)
	quit_btn.pressed.connect(_on_quit)
	play_btn.grab_focus()

func _on_play() -> void:
	get_tree().change_scene_to_file("res://scenes/hub.tscn")

func _on_settings() -> void:
	pass  # TODO: settings panel

func _on_quit() -> void:
	get_tree().quit()
