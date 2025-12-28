extends Node2D

@onready var exit_door = $World/ExitDoor
@onready var puzzle = $Puzzle
@onready var fire_start = $FireStart
@onready var end_fire = $EndFire
@onready var player = $Player
@onready var monster = $Monster
@onready var victory_area = $EndFire/VictoryArea
@onready var hud = $HUD

var game_over: bool = false
var puzzle_completed: bool = false

func _ready() -> void:
	# Increase pressure based on deaths (use GameManager now)
	var death_count = GameManager.get_level_death_count()
	fire_start.initial_duration = max(fire_start.min_duration, fire_start.initial_duration - (death_count * 5.0))
	
	if is_instance_valid(monster):
		monster.speed += (death_count * 15.0)
	
	# Show instructions
	if hud:
		hud.show_message("Light fires. Avoid the dark.\nFind the 4 symbols.", 5.0)
		hud.fade_from_black() 
	
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
		var target_radius = 400.0 # Increased base from 250
		if dist < 600.0:
			# Shrink radius as monster gets closer (min 150)
			target_radius = lerp(150.0, 400.0, (dist - 100.0) / 500.0)
		
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
	
	hud.show_message("The passage opens...", 3.0)

func _on_puzzle_failed(_noise) -> void:
	# Mistakes increase pressure - monster speed up slightly
	if is_instance_valid(monster):
		monster.speed += 20.0

func _on_death(reason: String) -> void:
	if game_over: return
	game_over = true
	
	# Notify GameManager
	GameManager.on_player_death()
	
	hud.show_message(reason, 2.0)
	await hud.fade_to_black(1.0)
	
	# Load death scene
	get_tree().change_scene_to_file("res://DeathScene.tscn")

func _on_victory(body: Node2D) -> void:
	if body == player and not game_over:
		game_over = true
		player.set_physics_process(false) # Stop player
		
		# Victory message
		hud.show_message("Level Complete!\n%s" % GameManager.get_level_name(), 3.0)
		await hud.fade_to_black(2.0)
		
		# Notify GameManager
		GameManager.on_level_complete()
