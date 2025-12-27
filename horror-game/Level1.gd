extends Node2D

@onready var exit_door = $World/ExitDoor
@onready var puzzle = $Puzzle
@onready var end_fire = $EndFire

func _ready() -> void:
	# Connect to puzzle success
	puzzle.puzzle_solved.connect(_on_puzzle_solved)
	
	# Initial state
	exit_door.get_node("CollisionShape2D").disabled = false
	exit_door.visible = true

func _on_puzzle_solved() -> void:
	# Open the door
	exit_door.get_node("CollisionShape2D").set_deferred("disabled", true)
	
	# Visual feedback for door opening
	var tween = create_tween()
	tween.tween_property(exit_door, "modulate:a", 0.0, 1.0)
	tween.tween_callback(exit_door.hide)
	
	print("Level Flow: Door Opened! Run to the light!")
