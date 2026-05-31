extends CanvasLayer
class_name DarknessOverlay

# TROLL — Level 19: Sudden Darkness
# Alternates between full darkness and brief flashes of visibility.

@export var dark_duration: float  = 1.8
@export var light_duration: float = 0.25

@onready var overlay: ColorRect = $Overlay

var _dark: bool   = true
var _timer: float = 0.0

func _ready() -> void:
	layer = 5
	_timer = dark_duration

func _process(delta: float) -> void:
	_timer -= delta
	if _timer <= 0.0:
		_dark = not _dark
		overlay.visible = _dark
		_timer = dark_duration if _dark else light_duration

func _troll_reset() -> void:
	_dark = true
	overlay.visible = true
	_timer = dark_duration
