extends Control

@onready var progress_bar = $ProgressBar
@onready var label = $Label

func _ready() -> void:
	# Connect to LightManager
	if LightManager:
		LightManager.light_changed.connect(_on_light_changed)
		LightManager.light_critical.connect(_on_light_critical)
		_on_light_changed(100.0)

func _on_light_changed(percent: float) -> void:
	progress_bar.value = percent
	label.text = "Light: %.0f%%" % percent
	
	# Color based on level
	if percent > 50.0:
		progress_bar.modulate = Color(1, 1, 0.5, 1)  # Yellow
	elif percent > 20.0:
		progress_bar.modulate = Color(1, 0.7, 0, 1)  # Orange
	else:
		progress_bar.modulate = Color(1, 0, 0, 1)  # Red

func _on_light_critical(_percent: float) -> void:
	# Flash warning
	var tween = create_tween().set_loops(3)
	tween.tween_property(label, "modulate", Color(1, 0, 0, 1), 0.2)
	tween.tween_property(label, "modulate", Color(1, 1, 1, 1), 0.2)
