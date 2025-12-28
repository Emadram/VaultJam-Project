extends CharacterBody2D

# The Doppelgänger: Mirrors player movement with inverted X-axis

@export var walk_speed: float = 100.0
@export var run_speed: float = 180.0

@onready var animated_sprite = $AnimatedSprite2D

enum State { MIMIC, HOSTILE }
var current_state: State = State.MIMIC
var player_target: Node2D = null

func _physics_process(_delta: float) -> void:
	if current_state == State.MIMIC:
		_process_mimic()
	elif current_state == State.HOSTILE:
		_process_hostile()
	
	move_and_slide()

func _process_mimic() -> void:
	# 1. Get same input as player
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# 2. Invert X axis logic
	input_dir.x = -input_dir.x
	
	# 3. Determine speed
	var is_running = Input.is_action_pressed("run")
	var current_speed = run_speed if is_running else walk_speed
	
	# 4. Move
	velocity = input_dir * current_speed
	
	# 5. Animation
	if input_dir.length() > 0:
		animated_sprite.play("run")
		if input_dir.x != 0:
			animated_sprite.flip_h = input_dir.x < 0
	else:
		animated_sprite.play("idle")

func _process_hostile() -> void:
	if not is_instance_valid(player_target):
		velocity = Vector2.ZERO
		return
		
	# Chase Player
	var direction = (player_target.global_position - global_position).normalized()
	
	# Mechanic: Darkness Rush
	# Check if player is near any light (Fire)
	var is_in_dark = _is_player_in_darkness()
	var speed_mult = 2.0 if is_in_dark else 0.8
	
	velocity = direction * (run_speed * speed_mult)
	
	animated_sprite.play("run")
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
		
	# Visual Feedback for Rush
	if is_in_dark:
		modulate = Color(2.0, 0.0, 0.0, 1.0) # Glowing Red
	else:
		modulate = Color(1.0, 0.0, 0.0, 1.0) # Normal Red
	
	# Collision logic (Kill player)
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.name == "Player" and collider.has_method("die"):
			collider.die()

func _is_player_in_darkness() -> bool:
	if not is_instance_valid(player_target):
		return false
		
	var overlay = get_node_or_null("/root/Level3/DarknessOverlay")
	if not overlay or not overlay.get("fire_nodes"):
		return true # Assume dark if no overlay logic
		
	var safe_distance = 300.0 # Radius around fire
	for fire in overlay.fire_nodes:
		if fire.global_position.distance_to(player_target.global_position) < safe_distance:
			return false # Player is safe
			
	return true # Player is in dark

func become_hostile(target: Node2D) -> void:
	current_state = State.HOSTILE
	player_target = target
	# Visual cue
	modulate = Color(1.0, 0.0, 0.0, 1.0) # Pure Red
