extends Control

func _ready() -> void:
	# Focus start button
	$VBoxContainer/StartButton.grab_focus()

func _on_start_pressed() -> void:
	# Start Level 1
	GameManager.start_level(1)

func _on_quit_pressed() -> void:
	get_tree().quit()
