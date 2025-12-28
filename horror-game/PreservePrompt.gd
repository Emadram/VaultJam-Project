extends Label

# Preserve prompt that shows when near fading objects

var is_showing: bool = false

func _ready() -> void:
	modulate.a = 0.0

func show_prompt() -> void:
	if is_showing:
		return
	is_showing = true
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.3)

func hide_prompt() -> void:
	if not is_showing:
		return
	is_showing = false
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
