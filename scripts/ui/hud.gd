extends CanvasLayer

# HUD in-level: deaths counter (top-left), timer (top-right), level name (top-center)
# Driven by LevelBase._hud_call()

@onready var deaths_label: Label = $TopBar/DeathsLabel
@onready var timer_label: Label  = $TopBar/TimerLabel
@onready var name_label: Label   = $TopBar/NameLabel
@onready var overlay: ColorRect  = $DeathOverlay
@onready var overlay_timer: Timer = $DeathOverlay/Timer

func _ready() -> void:
	overlay.visible = false

func update_deaths(count: int) -> void:
	deaths_label.text = "☠ %d" % count

func update_timer(time: float) -> void:
	var m := int(time / 60.0)
	var s := fmod(time, 60.0)
	timer_label.text = "%02d:%05.2f" % [m, s]

func set_level_name(lname: String) -> void:
	name_label.text = lname

func flash_death() -> void:
	overlay.visible = true
	overlay_timer.start(0.45)

func _on_timer_timeout() -> void:
	overlay.visible = false
