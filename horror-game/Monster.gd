extends CharacterBody2D

@export var speed: float = 180.0
@export var player_path: NodePath
@export var fire_path: NodePath

var player: Node2D
var fire_node: Node2D
var is_active: bool = false
var noise_detected: bool = false

func _ready() -> void:
	if player_path:
		player = get_node(player_path)
		# Connect to noise signal if player script has it
		if player.has_signal("noise_emitted"):
			player.noise_emitted.connect(_on_noise_detected)

	if fire_path:
		fire_node = get_node(fire_path)
		# Connect to fire extinguished signal
		if fire_node.has_signal("fire_extinguished"):
			fire_node.fire_extinguished.connect(_on_fire_extinguished)
			# Also need to know when it's relit, but the current Fire.gd doesn't emit "relit".
			# I'll just check is_lit in process for simplicity or add the signal later.

@export var light_radius_threshold: float = 220.0 # Slightly larger than light radius
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Check darkness state from fire node directly if valid
	var is_dark = true
	if is_instance_valid(fire_node):
		if fire_node.get("is_lit"):
			is_dark = false
			activation_timer = 0.0 # Reset delay when light exists
	
	# Visibility Logic:
	# If dark, check if player is close enough (within light radius).
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
	
	# Determine if monster should move
	if is_dark or noise_detected:
		# Add a slight delay before movement starts in darkness
		if is_dark and activation_timer < activation_delay:
			activation_timer += delta
			return
			
		if is_instance_valid(player):
			var direction = (player.global_position - global_position).normalized()
			velocity = direction * speed
			
			# Rotation Fix: Flip instead of rotating
			if direction.x != 0:
				animated_sprite.flip_h = direction.x < 0
			rotation = 0 # Ensure upright
			
			move_and_slide()
			
			# Simple collision handling for killing
			for i in get_slide_collision_count():
				var collision = get_slide_collision(i)
				var collider = collision.get_collider()
				if collider == player and collider.has_method("die"):
					collider.die()
	else:
		velocity = Vector2.ZERO

func _on_noise_detected(level: float) -> void:
	if level > 0.5:
		noise_detected = true
		# Reset noise detection after a short delay
		await get_tree().create_timer(1.0).timeout
		noise_detected = false

func _on_fire_extinguished() -> void:
	# Keep track of state if needed, but polling is safer for this simple setup
	pass
