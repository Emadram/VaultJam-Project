extends Node2D

# Object that fades away unless preserved

signal object_vanished(object: Node2D)
signal object_preserved(object: Node2D)

enum State { SOLID, FADING, PRESERVED, VANISHED }

@export var fade_rate: float = 0.5  # % per second (default: ~3 mins to fade)
@export var can_be_preserved: bool = true
@export var is_critical: bool = false  # If true, game over when vanished

var current_state: State = State.SOLID
var fade_progress: float = 0.0  # 0.0 = solid, 1.0 = vanished
var fade_speed_multiplier: float = 1.0  # Modified by relight trade-offs

@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")
@onready var area: Area2D = get_node_or_null("PreserveArea")
var debris: CPUParticles2D

func _ready() -> void:
	if sprite and sprite.material == null:
		# Create shader material
		var shader_material = ShaderMaterial.new()
		shader_material.shader = load("res://fading.gdshader")
		shader_material.set_shader_parameter("noise_texture", load("res://noise.png"))
		sprite.material = shader_material
	
	# Add debris particles
	var debris_scene = load("res://DebrisParticles.tscn")
	if debris_scene:
		debris = debris_scene.instantiate()
		debris.one_shot = false # Ensure continuous initially
		add_child(debris)
		# Match emission shape to sprite size if possible
		if sprite:
			var size = sprite.scale * sprite.texture.get_size() if sprite.texture else Vector2(100, 100)
			debris.emission_rect_extents = size / 2.0
	
	# Setup interaction area if it exists
	if area:
		area.body_entered.connect(_on_body_entered)
		area.body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if current_state == State.FADING:
		# Fade over time
		fade_progress += (fade_rate * fade_speed_multiplier * delta) / 100.0
		fade_progress = min(1.0, fade_progress)
		
		# Update shader
		if sprite and sprite.material:
			sprite.material.set_shader_parameter("fade_progress", fade_progress)
		
		# Update particles
		if debris:
			debris.emitting = true
			var particle_count = int(30 * fade_progress)
			if particle_count < 1: particle_count = 1
			debris.amount = particle_count
		
		# Check if vanished
		if fade_progress >= 1.0:
			_on_vanished()
	elif debris and current_state != State.FADING:
		debris.emitting = false

func start_fading() -> void:
	if current_state == State.SOLID:
		current_state = State.FADING

func set_fade_speed_multiplier(multiplier: float) -> void:
	fade_speed_multiplier = multiplier

func preserve() -> void:
	if current_state != State.PRESERVED and can_be_preserved:
		current_state = State.PRESERVED
		fade_progress = max(0.0, fade_progress - 0.1)  # Slight recovery
		
		# Update shader
		if sprite and sprite.material:
			sprite.material.set_shader_parameter("fade_progress", fade_progress)
		
		# Visual feedback
		_create_preserve_effect()
		object_preserved.emit(self)
		
		# Stop debris
		if debris:
			debris.emitting = false

func _create_preserve_effect() -> void:
	# Golden glow outline
	if sprite:
		var glow_tween = create_tween()
		glow_tween.tween_property(sprite, "modulate", Color(1.5, 1.5, 1.0, 1.0), 0.3)
		glow_tween.tween_property(sprite, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.5)

func _on_vanished() -> void:
	current_state = State.VANISHED
	object_vanished.emit(self)
	
	if debris:
		# VISUAL POLISH: Burst on vanish
		debris.emitting = false # Stop continuous
		debris.explosiveness = 1.0
		debris.amount = 50
		debris.one_shot = true
		debris.emitting = true
	
	if is_critical:
		# Trigger game over
		pass  # Level will handle this
	
	# Hide or remove
	visible = false

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and current_state == State.FADING:
		# Notify player they can preserve this object
		if body.has_method("set_nearby_fading_object"):
			body.set_nearby_fading_object(self)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		# Clear nearby object
		if body.has_method("clear_nearby_fading_object"):
			body.clear_nearby_fading_object()

func get_state_name() -> String:
	match current_state:
		State.SOLID: return "SOLID"
		State.FADING: return "FADING"
		State.PRESERVED: return "PRESERVED"
		State.VANISHED: return "VANISHED"
		_: return "UNKNOWN"
