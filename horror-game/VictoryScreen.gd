extends Control

@onready var total_deaths_label = $VBoxContainer/TotalDeaths
@onready var completion_time_label = $VBoxContainer/CompletionTime

func _ready() -> void:
	# Display statistics
	total_deaths_label.text = "Total Deaths: %d" % GameManager.total_deaths
	
	# Format time
	var total_time = 0.0
	for time in GameManager.level_times.values():
		total_time += time
	
	var minutes = int(total_time / 60.0)
	var seconds = int(total_time) % 60
	completion_time_label.text = "Time: %d:%02d" % [minutes, seconds]
	
	# Focus restart button
	$VBoxContainer/RestartButton.grab_focus()

func _on_restart_pressed() -> void:
	# Return to main menu
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
