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

# Level Configuration
const LEVEL_SCENES = {
	1: "res://Level1.tscn",
	# Future levels:
	# 2: "res://Level2.tscn",
	# 3: "res://Level3.tscn",
}

const LEVEL_NAMES = {
	1: "The Memory Hall",
	2: "The Portrait Gallery",
	3: "The Crypt"
}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Continue running during pause

func start_level(level_num: int) -> void:
	current_level = level_num
	level_start_time = Time.get_ticks_msec() / 1000.0
	
	if not level_deaths.has(level_num):
		level_deaths[level_num] = 0
	
	# Load the level scene
	if LEVEL_SCENES.has(level_num):
		get_tree().change_scene_to_file(LEVEL_SCENES[level_num])
	else:
		push_error("Level %d not found!" % level_num)

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
	on_player_death()
	start_level(current_level)

func _show_final_victory() -> void:
	# Load victory screen
	get_tree().change_scene_to_file("res://VictoryScreen.tscn")

func get_level_death_count() -> int:
	return level_deaths.get(current_level, 0)

func get_level_name() -> String:
	return LEVEL_NAMES.get(current_level, "Unknown Level")
