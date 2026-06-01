extends CharacterBody2D
class_name Player

const SPEED         := 260.0
const JUMP_VELOCITY := -540.0
const GRAVITY       := 1400.0
const DASH_SPEED    := 600.0

# Hitbox expansion for imprecise input on mobile (px per side)
const MOBILE_HB_EXPAND := 8.0

signal died

@onready var abilities: Node = $PlayerAbilities

var _facing_right: bool = true
var gravity_multiplier: float = 1.0   # writable by troll levels
var input_reversed: bool = false       # writable by ControlReverser
var extra_speed: float = 0.0           # writable by SpeedAccelerator
var _is_mobile: bool = false

func _ready() -> void:
	_is_mobile = OS.get_name() in ["Android", "iOS"]
	abilities.setup(self)

func _physics_process(delta: float) -> void:
	if abilities.is_dashing():
		_apply_dash(delta)
		move_and_slide()
		return

	# Gravity
	if not is_on_floor():
		velocity.y += GRAVITY * gravity_multiplier * delta
	else:
		abilities.reset_on_land()

	# Horizontal
	var dir := Input.get_axis("move_left", "move_right")
	if input_reversed:
		dir = -dir
	if dir != 0.0:
		velocity.x = dir * (SPEED + extra_speed) * abilities.get_speed_multiplier()
		_facing_right = dir > 0.0
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED * 4.0 * delta)

	# Jump
	var held     := Input.is_action_pressed("jump")
	var pressed  := Input.is_action_just_pressed("jump")
	if abilities.try_jump(held, pressed):
		var wall_dir: float = abilities.get_wall_jump_dir()
		var charge: float   = abilities.consume_charge()
		if wall_dir != 0.0:
			velocity.x = wall_dir * SPEED
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY * charge
		_sfx("jump")

	# Dash
	if Input.is_action_just_pressed("dash"):
		if abilities.try_dash():
			_sfx("dash")

	abilities.process(delta)
	move_and_slide()

func _apply_dash(_delta: float) -> void:
	var dir := 1.0 if _facing_right else -1.0
	velocity.x = dir * DASH_SPEED
	velocity.y = 0.0

func respawn(spawn_pos: Vector2) -> void:
	global_position = spawn_pos
	velocity = Vector2.ZERO
	gravity_multiplier = 1.0
	input_reversed = false
	extra_speed = 0.0

func kill() -> void:
	emit_signal("died")

func _sfx(sfx_name: String) -> void:
	var sfx := get_node_or_null("/root/SFX")
	if sfx:
		sfx.play(sfx_name)
