extends Control

func _ready() -> void:
	# Connect buttons
	$VBoxContainer/Level1Button.pressed.connect(func(): GameManager.start_level(1))
	$VBoxContainer/Level2Button.pressed.connect(func(): GameManager.start_level(2))
	$VBoxContainer/Level3Button.pressed.connect(func(): GameManager.start_level(3))
	$VBoxContainer/QuitButton.pressed.connect(func(): get_tree().quit())
	
	# Focus first level button
	$VBoxContainer/Level1Button.grab_focus()
