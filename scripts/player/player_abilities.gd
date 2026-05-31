extends Node
class_name PlayerAbilities

# Unlockable abilities component — all gated by GameState.unlocked_abilities.
# Abilities unlocked per level: double_jump@7, dash@15, sprint@29, wall_jump@49, charged_jump@74

const DASH_SPEED       := 600.0
const DASH_DURATION    := 0.15
const DASH_COOLDOWN    := 0.80
const WALL_JUMP_BUFFER := 0.15
const MAX_JUMP_CHARGE  := 0.40
const CHARGE_MULTIPLIER := 1.8

var _player: CharacterBody2D
var _gs: Node

# Double jump
var _jumps_left: int = 1

# Dash
var _can_dash: bool = true
var _dash_cooldown_timer: float = 0.0
var _is_dashing: bool = false
var _dash_time_left: float = 0.0

# Wall jump
var _wall_jump_buffer: float = 0.0

# Charged jump
var _jump_hold_time: float = 0.0
var _is_charging: bool = false

func setup(player: CharacterBody2D) -> void:
	_player = player
	_gs = get_node("/root/GameState")

# Called by player when landing
func reset_on_land() -> void:
	_jumps_left = 2 if _gs.has_ability("double_jump") else 1
	_can_dash = true

# Returns true if a jump should be applied this frame.
# Wall-jump direction is retrieved separately via get_wall_jump_dir().
func try_jump(is_pressed: bool, is_just_pressed: bool) -> bool:
	# Charged jump accumulation (desktop: hold space; handled in player.gd)
	if _gs.has_ability("charged_jump") and is_pressed and _player.is_on_floor():
		_is_charging = true
		_jump_hold_time = min(_jump_hold_time + _player.get_process_delta_time(), MAX_JUMP_CHARGE)

	if is_just_pressed:
		# Wall jump
		if _gs.has_ability("wall_jump") and _player.is_on_wall_only():
			_wall_jump_buffer = WALL_JUMP_BUFFER
			_is_charging = false
			_jump_hold_time = 0.0
			return true
		# Normal / double jump
		if _jumps_left > 0:
			_jumps_left -= 1
			var was_charging := _is_charging
			_is_charging = false
			# Charged jump fires here only if we were holding
			if was_charging and _gs.has_ability("charged_jump"):
				pass  # multiplier applied by caller
			_jump_hold_time = 0.0 if not was_charging else _jump_hold_time
			return true

	# Release charged jump without jumping (cancelled)
	if not is_pressed and _is_charging:
		_is_charging = false
		_jump_hold_time = 0.0

	return false

func consume_charge() -> float:
	# Returns multiplier and resets charge
	if not _gs.has_ability("charged_jump"):
		return 1.0
	var ratio := _jump_hold_time / MAX_JUMP_CHARGE
	_jump_hold_time = 0.0
	_is_charging = false
	return lerpf(1.0, CHARGE_MULTIPLIER, ratio)

func try_dash() -> bool:
	if not _gs.has_ability("dash"):
		return false
	if _can_dash and not _is_dashing:
		_can_dash = false
		_is_dashing = true
		_dash_time_left = DASH_DURATION
		_dash_cooldown_timer = 0.0
		return true
	return false

func get_speed_multiplier() -> float:
	if _gs.has_ability("sprint") and Input.is_action_pressed("sprint"):
		return 1.6
	return 1.0

func get_wall_jump_dir() -> float:
	if _wall_jump_buffer > 0.0:
		_wall_jump_buffer = 0.0
		return -_player.get_wall_normal().x
	return 0.0

func process(delta: float) -> void:
	if _wall_jump_buffer > 0.0:
		_wall_jump_buffer -= delta

	if not _can_dash:
		_dash_cooldown_timer += delta
		if _dash_cooldown_timer >= DASH_COOLDOWN and not _is_dashing:
			_can_dash = true

	if _is_dashing:
		_dash_time_left -= delta
		if _dash_time_left <= 0.0:
			_is_dashing = false

func is_dashing() -> bool:
	return _is_dashing
