extends CanvasLayer

# HUD in-level: deaths counter (top-left), timer (top-right), level name (top-center)
# Driven by LevelBase._hud_call()

@onready var deaths_label: Label = $TopBar/DeathsLabel
@onready var timer_label: Label  = $TopBar/TimerLabel
@onready var name_label: Label   = $TopBar/NameLabel
@onready var overlay: ColorRect  = $DeathOverlay
@onready var overlay_timer: Timer = $DeathOverlay/Timer
@onready var mobile_controls: Control = $MobileControls

func _ready() -> void:
	overlay.visible = false
	_setup_mobile_controls()

func _exit_tree() -> void:
	_release_mobile_actions()

func _setup_mobile_controls() -> void:
	var is_mobile: bool = OS.get_name() in ["Android", "iOS"]
	mobile_controls.visible = is_mobile

func _release_mobile_actions() -> void:
	Input.action_release("move_left")
	Input.action_release("move_right")
	Input.action_release("jump")
	Input.action_release("dash")
	Input.action_release("sprint")

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
