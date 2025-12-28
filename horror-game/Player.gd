extends CharacterBody2D

@export var walk_speed: float = 80.0
@export var run_speed: float = 140.0
@export var noise_radius: float = 400.0  # How far running noise travels
@export var preserve_cost: float = 15.0  # Light cost to preserve object

@onready var animated_sprite = $AnimatedSprite2D

signal noise_made(position: Vector2, radius: float)

var is_alive: bool = true
var nearby_fading_object: Node2D = null

func _ready() -> void:
	# Connect to fading object areas if in Level 2
	pass

func _physics_process(_delta: float) -> void:
	if not is_alive:
		return
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Notify LightManager of movement state
	if LightManager:
		LightManager.set_player_moving(input_dir.length() > 0)
	
	# Determine speed based on run input
	var is_running = Input.is_action_pressed("run")
	var current_speed = run_speed if is_running else walk_speed
	
	# Make noise if running (emit signal for monster to detect)
	if is_running and input_dir.length() > 0:
		noise_made.emit(global_position, noise_radius)
	
	velocity = input_dir * current_speed
	move_and_slide()
	
	# Animation logic (use input_dir to avoid flicker)
	if input_dir.length() > 0:
		animated_sprite.play("run")
		# Flip sprite based on horizontal movement
		if input_dir.x != 0:
			animated_sprite.flip_h = input_dir.x < 0
	else:
		animated_sprite.play("idle")

func _input(event: InputEvent) -> void:
	# Preserve mechanic (E key)
	if event.is_action_pressed("ui_accept") and nearby_fading_object:
		_try_preserve()

func _try_preserve() -> void:
	if not LightManager or not nearby_fading_object:
		return
	
	# Check if we have enough light
	if LightManager.consume_light(preserve_cost):
		# Preserve the object
		if nearby_fading_object.has_method("preserve"):
			nearby_fading_object.preserve()
	else:
		# Not enough light - show feedback
		print("Not enough light to preserve!")

func set_nearby_fading_object(obj: Node2D) -> void:
	nearby_fading_object = obj
	# Show preserve prompt via HUD
	var hud = get_node_or_null("/root/Level2/HUD")
	if hud and hud.has_method("show_prompt"):
		hud.show_prompt()

func clear_nearby_fading_object() -> void:
	nearby_fading_object = null
	# Hide preserve prompt via HUD
	var hud = get_node_or_null("/root/Level2/HUD")
	if hud and hud.has_method("hide_prompt"):
		hud.hide_prompt()

func die() -> void:
	if not is_alive:
		return
	is_alive = false
	set_physics_process(false)
	
	# Death animation disabled until sprite sheets are properly split
	# animated_sprite.play("die")
	
	# Fade out effect
	var tween = create_tween()
	tween.tween_property(animated_sprite, "modulate:a", 0.0, 1.0)
	queue_free()
