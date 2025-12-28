extends CharacterBody2D

@export var speed: float = 180.0
@export var player_path: NodePath
@export var fire_path: NodePath

var player: Node2D
var fire_node: Node2D
var is_active: bool = false
var noise_detected: bool = false
var player_in_darkness: bool = false  # NEW: Track if player is in dark area
var darkness_boost: float = 2.0  # NEW: Speed multiplier in darkness

var activation_timer: float = 0.0
@export var activation_delay: float = 0.8
@export var light_radius_threshold: float = 280.0 # Slightly larger than light radius to ensure invisibility
@export var patrol_waypoints: Array[Vector2] = [] # Waypoints for patrol
var current_waypoint_index: int = 0
var patrol_speed: float = 60.0 # Slower when patrolling
var last_noise_position: Vector2 = Vector2.ZERO
var noise_detected_timer: float = 0.0
var noise_detection_duration: float = 3.0  # How long to remember noise
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	# Get references
	if player_path:
		player = get_node(player_path)
		# Connect to player noise signal
		if player.has_signal("noise_made"):
			player.noise_made.connect(_on_noise_detected)
	
	if fire_path:
		fire_node = get_node(fire_path)

func _on_noise_detected(noise_position: Vector2, _radius: float) -> void:
	# Monster hears running and moves toward it
	last_noise_position = noise_position
	noise_detected_timer = noise_detection_duration
	noise_detected = true

func _physics_process(delta: float) -> void:
	# Decrease noise timer
	if noise_detected_timer > 0:
		noise_detected_timer -= delta
		if noise_detected_timer <= 0:
			noise_detected = false
	
	# Determine Logic Mode
	if is_instance_valid(fire_node):
		_process_level1_logic(delta)
	else:
		_process_level2_logic(delta)

func _process_level1_logic(delta: float) -> void:
	# Check darkness state from fire node directly if valid
	var is_dark = true
	if fire_node.get("is_lit"):
		is_dark = false
		activation_timer = 0.0 # Reset delay when light exists
	
	# Visibility Logic:
	if is_dark:
		if is_instance_valid(player):
			var dist = global_position.distance_to(player.global_position)
			# Invisible if outside light radius
			visible = dist <= light_radius_threshold
			# Reset activation if invisible to prevent "ghost" movement
			if not visible:
				activation_timer = 0.0
				return # Stop processing movement if invisible
		else:
			visible = false
	else:
		visible = true # Always visible if lights are on
	
	# Determine behavior: Patrol when lit, Chase when dark OR noise detected
	# Check if player is in darkness (not near fires)
	player_in_darkness = _is_player_in_darkness()
	
	if is_dark or noise_detected:
		_chase_player(delta, is_dark)
	elif patrol_waypoints.size() > 0 and not is_dark:
		_patrol(delta)
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
		animated_sprite.speed_scale = 1.0
		move_and_slide()

func _is_player_in_darkness() -> bool:
	# Check if player is far from any fire sources
	if not is_instance_valid(player):
		return false
	
	var fires = get_tree().get_nodes_in_group("fires")
	var safe_distance = 450.0  # Distance at which fire protects player
	
	for fire in fires:
		if fire.has_method("get") and fire.get("is_lit"):
			var dist = player.global_position.distance_to(fire.global_position)
			if dist < safe_distance:
				return false  # Player is near lit fire, not in darkness
	
	return true  # Player is in darkness - no nearby fires

func _process_level2_logic(delta: float) -> void:
	# LEVEL 2 LOGIC: "Last Light"
	visible = true # Always visible in Level 2
	
	# Detection Logic linked to LightManager
	var detection_range = 300.0
	if LightManager:
		# Higher light = larger detection range (Monster sees you better)
		var light_p = LightManager.get_light_percent()
		detection_range = lerp(200.0, 700.0, light_p / 100.0)
	
	var sees_player = false
	if is_instance_valid(player):
		var dist = global_position.distance_to(player.global_position)
		if dist < detection_range:
			sees_player = true
	
	if sees_player or noise_detected:
		_chase_player(delta, false) # False means no start delay
	elif patrol_waypoints.size() > 0:
		_patrol(delta)
	else:
		velocity = Vector2.ZERO
		animated_sprite.play("idle")
		animated_sprite.speed_scale = 1.0
		move_and_slide()

func _chase_player(delta: float, use_delay: bool) -> void:
	# Add a slight delay before movement starts (optional)
	if use_delay and activation_timer < activation_delay:
		activation_timer += delta
		return
		
	if is_instance_valid(player):
		var target_position = last_noise_position if noise_detected else player.global_position
		var direction = (target_position - global_position).normalized()
		
		# DARKNESS BOOST: 2x speed if player is in darkness OR making noise
		var effective_speed = speed
		if player_in_darkness or noise_detected:
			effective_speed = speed * darkness_boost  # 2x speed in darkness!
			animated_sprite.modulate = Color(1.5, 0.3, 0.3)  # Red glow when rushing
		else:
			animated_sprite.modulate = Color(1, 1, 1)  # Normal color
		
		velocity = direction * effective_speed
		
		# Rotation Fix: Flip instead of rotating
		if direction.x != 0:
			animated_sprite.flip_h = direction.x < 0
		rotation = 0 # Ensure upright
		
		# Play animation
		if velocity.length() > 0:
			animated_sprite.play("run")
			animated_sprite.speed_scale = 1.5 # Frantic movement
		else:
			animated_sprite.play("idle")
		
		move_and_slide()
		
		# Simple collision handling for killing
		for i in range(get_slide_collision_count()):
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider == player and collider.has_method("die"):
				collider.die()

func _patrol(_delta: float) -> void:
	var target_waypoint = patrol_waypoints[current_waypoint_index]
	var direction = (target_waypoint - global_position).normalized()
	
	# Check if reached waypoint
	if global_position.distance_to(target_waypoint) < 50.0:
		current_waypoint_index = (current_waypoint_index + 1) % patrol_waypoints.size()
	
	velocity = direction * patrol_speed
	
	# Flip sprite based on direction
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0
	rotation = 0
	
	# Play animation
	if velocity.length() > 0:
		animated_sprite.play("run")
		animated_sprite.speed_scale = 1.0 # Normal speed
	else:
		animated_sprite.play("idle")
	
	move_and_slide()
