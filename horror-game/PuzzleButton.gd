extends Area2D

signal pressed(index)

@export var index: int = 0

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Puzzle Button clicked: ", index)
		pressed.emit(index)

func _mouse_enter() -> void:
	modulate = Color(1.5, 1.5, 1.5, 1.0) # Brighten on hover

func _mouse_exit() -> void:
	modulate = Color(1.0, 1.0, 1.0, 1.0) # Reset on exit
