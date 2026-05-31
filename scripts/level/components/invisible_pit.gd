extends Node2D
class_name InvisiblePit

# TROLL — Level 8: Invisible Pit
# A gap in the floor that is completely invisible.
# The StaticBody2D platforms on either side look continuous but have a hidden gap.
# The death zone underneath catches the player.
# This component simply manages the visual deception — no physics needed here,
# the pit is baked into the scene layout (no floor tile in the gap).

# The "invisible" effect: the floor visual (ColorRect) spans the full width
# COVERING the gap, while the actual collision shapes have the gap.
# On _troll_reset nothing needs to change — it's a static visual trap.

@onready var cover_visual: ColorRect = $CoverVisual   # opaque rect hiding the gap

func _troll_reset() -> void:
	pass  # Static trap — nothing to reset
