extends Node

# Singleton for managing global game state and level transitions

signal level_completed(level_name: String)
signal player_died(death_count: int)

# Game State
var current_level: int = 1
var total_deaths: int = 0
var level_deaths: Dictionary = {} # Track deaths per level
var level_times: Dictionary = {} # Track completion times
var level_start_time: float = 0.0

var transition_layer: CanvasLayer
var transition_rect: ColorRect

# Level Configuration
const LEVEL_SCENES = {
	1: "res://Level1.tscn",
	2: "res://Level2.tscn",
	3: "res://scenes/Level3.tscn"
}

const LEVEL_NAMES = {
	1: "The Cellar",
	2: "Last Light",
	3: "The Mirror Hall"
}

func _ready() -> void:
	# Create persistent transition layer
	transition_layer = CanvasLayer.new()
	transition_layer.layer = 100 # Topmost (was 1000, 100 is fine)
	add_child(transition_layer)
	
	transition_rect = ColorRect.new()
	transition_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	transition_rect.color = Color.BLACK
	transition_rect.modulate.a = 0.0
	transition_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_layer.add_child(transition_rect)

func start_level(level_num: int) -> void:
	current_level = level_num
	
	if not level_deaths.has(level_num):
		level_deaths[level_num] = 0
	
	# Load the level scene with transition
	if LEVEL_SCENES.has(level_num):
		_transition_to_scene(LEVEL_SCENES[level_num])
	else:
		push_error("Level %d not found!" % level_num)

func _transition_to_scene(path: String) -> void:
	# Fade Out
	transition_rect.mouse_filter = Control.MOUSE_FILTER_STOP # Block input
	var tween = create_tween()
	tween.tween_property(transition_rect, "modulate:a", 1.0, 0.5)
	await tween.finished
	
	# Change Scene
	get_tree().change_scene_to_file(path)
	
	# Update Timer
	level_start_time = Time.get_ticks_msec() / 1000.0
	
	# Fade In
	tween = create_tween()
	tween.tween_property(transition_rect, "modulate:a", 0.0, 0.5)
	await tween.finished
	transition_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func on_player_death() -> void:
	total_deaths += 1
	level_deaths[current_level] = level_deaths.get(current_level, 0) + 1
	player_died.emit(level_deaths[current_level])

func on_level_complete() -> void:
	var completion_time = (Time.get_ticks_msec() / 1000.0) - level_start_time
	level_times[current_level] = completion_time
	
	level_completed.emit(LEVEL_NAMES.get(current_level, "Unknown"))
	
	# Progress to next level
	var next_level = current_level + 1
	if LEVEL_SCENES.has(next_level):
		# Delay for cinematic effect
		await get_tree().create_timer(2.0).timeout
		start_level(next_level)
	else:
		# Game complete!
		_show_final_victory()

func restart_current_level() -> void:
	# Death already counted in Level1.gd, just restart
	start_level(current_level)

func _show_final_victory() -> void:
	# Load victory screen
	get_tree().change_scene_to_file("res://VictoryScreen.tscn")

func get_level_death_count() -> int:
	return level_deaths.get(current_level, 0)

func get_level_name() -> String:
	return LEVEL_NAMES.get(current_level, "Unknown Level")
