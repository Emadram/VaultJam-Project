extends CanvasLayer

class_name HUD

@onready var light_meter = $LightMeter
@onready var preserve_prompt = $PreservePrompt
@onready var fade_rect = $FadeRect
@onready var message_label = $MessageLabel

# Clean API for UI interactions

func show_prompt() -> void:
	preserve_prompt.show_prompt()

func hide_prompt() -> void:
	preserve_prompt.hide_prompt()

func show_message(text: String, duration: float = 2.0) -> void:
	message_label.text = text
	message_label.modulate.a = 1.0
	if duration > 0:
		var tween = create_tween()
		tween.tween_interval(duration)
		tween.tween_property(message_label, "modulate:a", 0.0, 1.0)

func flash_warning(text: String) -> void:
	message_label.text = text
	var tween = create_tween()
	tween.tween_property(message_label, "modulate:a", 1.0, 0.3)
	tween.tween_property(message_label, "modulate:a", 0.0, 1.0)

func fade_to_black(duration: float = 1.0) -> Signal:
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, duration)
	return tween.finished

func fade_from_black(duration: float = 1.0) -> Signal:
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, duration)
	return tween.finished
