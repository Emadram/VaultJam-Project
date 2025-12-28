extends Node2D

# Level 2: "Last Light" - Main level controller

@onready var player = $Player
@onready var hud = $HUD  # Reference to new HUD node

var game_over: bool = false

func _ready() -> void:
	# Reset LightManager
	LightManager.reset_light()
	
	# Connect signals
	LightManager.light_depleted.connect(_on_light_depleted)
	LightManager.light_critical.connect(_on_light_critical)
	
	# Start all fading objects
	_start_fading_objects()

var global_fade_multiplier: float = 1.0

func _start_fading_objects() -> void:
	# Find all FadingObject nodes and start them fading
	for child in get_tree().get_nodes_in_group("fading_objects"):
		if child.has_method("start_fading"):
			child.start_fading()
			
			# Connect preservation signal for "The Twist"
			if not child.object_preserved.is_connected(_on_object_preserved):
				child.object_preserved.connect(_on_object_preserved)
			
			# Connect signal if critical
			if child.is_critical and not child.object_vanished.is_connected(_on_object_vanished):
				child.object_vanished.connect(_on_object_vanished)

func _on_object_preserved(_obj: Node2D) -> void:
	# THE TWIST: Preserving one thing makes everything else fade faster
	global_fade_multiplier += 0.15 # Increase speed by 15%
	
	# Update all fading objects
	for child in get_tree().get_nodes_in_group("fading_objects"):
		if child.has_method("set_fade_speed_multiplier"):
			child.set_fade_speed_multiplier(global_fade_multiplier)
	
	# Visual/Audio feedback (World Groan)
	if hud:
		hud.flash_warning("The shadows deepen...")
		# TODO: Screen shake or sound effect

func _on_object_vanished(_obj: Node2D) -> void:
	_on_death("A critical path has vanished!")

func _on_light_depleted() -> void:
	if game_over: return
	game_over = true
	_on_death("Your light faded completely...")

func _on_light_critical(percent: float) -> void:
	# Visual warning at 20%
	if hud:
		hud.flash_warning("Light Critical: %.0f%%" % percent)

func _on_death(reason: String) -> void:
	if game_over: return
	game_over = true
	
	# Stop light drain
	if LightManager:
		LightManager.set_process(false)
	
	# Play death animation
	if player and player.has_method("die"):
		player.die()
	
	# Notify GameManager
	GameManager.on_player_death()
	
	# Show death message via HUD
	if hud:
		hud.show_message(reason, 0) # 0 means dont auto-hide
		await hud.fade_to_black(1.0)
	
	await get_tree().create_timer(1.0).timeout
	
	# Load death scene
	get_tree().change_scene_to_file("res://DeathScene.tscn")

func _on_victory(_body: Node2D) -> void:
	if game_over: return
	game_over = true
	
	# Stop light drain
	if LightManager:
		LightManager.set_process(false)
	
	if hud:
		hud.show_message("Light Preserved!\nLevel 2 Complete", 0)
		await hud.fade_to_black(2.0)
	
	GameManager.on_level_complete()
