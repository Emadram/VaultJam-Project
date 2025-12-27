extends Node2D

@onready var exit_door = $World/ExitDoor
@onready var puzzle = $Puzzle
@onready var fire_start = $FireStart
@onready var end_fire = $EndFire
@onready var player = $Player
@onready var monster = $Monster
@onready var victory_area = $EndFire/VictoryArea
@onready var fade_rect = $GameUI/FadeRect
@onready var message_label = $GameUI/MessageLabel

static var deaths_count: int = 0
var game_over: bool = false
var puzzle_completed: bool = false

func _ready() -> void:
	# Increase pressure based on deaths
	fire_start.initial_duration = max(fire_start.min_duration, fire_start.initial_duration - (deaths_count * 5.0))
	monster.speed += (deaths_count * 15.0)
	
	# Connections
	puzzle.puzzle_solved.connect(_on_puzzle_solved)
	puzzle.puzzle_failed.connect(_on_puzzle_failed)
	victory_area.body_entered.connect(_on_victory)
	
	# Initial Setup
	exit_door.get_node("CollisionShape2D").disabled = false
	exit_door.visible = true

@onready var darkness_overlay = $DarknessOverlay

func _process(_delta: float) -> void:
	# Proximity Effect: Shrink light radius when monster is close
	if is_instance_valid(player) and is_instance_valid(monster):
		var dist = player.global_position.distance_to(monster.global_position)
		var target_radius = 250.0 # Default
		if dist < 400.0:
			# Shrink radius as monster gets closer (min 100)
			target_radius = lerp(100.0, 250.0, (dist - 100.0) / 300.0)
		
		# Smoothly change radius
		darkness_overlay.light_radius = lerp(darkness_overlay.light_radius, target_radius, 0.1)

	# Check for player death
	if not is_instance_valid(player) and not game_over:
		_on_death("The darkness claimed you.")

func _on_puzzle_solved() -> void:
	puzzle_completed = true
	# Open the door
	exit_door.get_node("CollisionShape2D").set_deferred("disabled", true)
	var tween = create_tween()
	tween.tween_property(exit_door, "modulate:a", 0.0, 1.0)
	tween.tween_callback(exit_door.hide)

func _on_puzzle_failed(_noise) -> void:
	# Mistakes increase pressure - monster speed up slightly
	monster.speed += 20.0

func _on_death(reason: String) -> void:
	if game_over: return
	game_over = true
	
	# Visuals
	message_label.text = reason
	var tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, 1.0)
	
	await get_tree().create_timer(2.0).timeout
	
	# Retry Flow
	_reset_level()

func _reset_level() -> void:
	deaths_count += 1
	game_over = false
	message_label.text = ""
	
	# Reset Player (Reloading scene or manual reset)
	# Manual reset is cleaner for persistent progress (like monster speed)
	get_tree().reload_current_scene()

func _on_victory(body: Node2D) -> void:
	if body == player and not game_over:
		game_over = true
		player.set_physics_process(false) # Stop player
		
		# Ambiguous Ending
		message_label.text = "Some memories are better left behind."
		
		var tween = create_tween()
		tween.tween_property(fade_rect, "modulate:a", 1.0, 3.0)
		
		await tween.finished
		await get_tree().create_timer(2.0).timeout
		get_tree().quit()

