extends CharacterBody2D

# Movement speeds
@export var walk_speed: float = 100.0
@export var run_speed: float = 180.0

# Noise emission
signal noise_emitted(level: float)
var noise_level: float = 0.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Quit on ESC key
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	# Get input direction
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Determine if running
	var is_running := Input.is_action_pressed("run") and input_dir.length() > 0
	
	# Set speed based on running state
	var current_speed := run_speed if is_running else walk_speed
	
	# Set velocity
	velocity = input_dir * current_speed
	
	# Update animation based on movement
	if velocity.length() > 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")
	
	# Emit noise when running
	noise_level = 1.0 if is_running else 0.0
	if is_running:
		noise_emitted.emit(noise_level)
	
	# Move character
	move_and_slide()

func die() -> void:
	queue_free()
