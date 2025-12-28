extends Area2D

# Light Orb - Collectible that restores player's light

@export var light_amount: float = 25.0  # % of light to restore
@export var pulse_speed: float = 2.0

@onready var sprite = $Sprite2D
@onready var particles = $CPUParticles2D

var collected: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	# Start pulsing animation
	_start_pulse()

func _start_pulse() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(sprite, "scale", Vector2(1.3, 1.3), 1.0 / pulse_speed)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 1.0 / pulse_speed)

func _on_body_entered(body: Node2D) -> void:
	if collected or body.name != "Player":
		return
	
	collected = true
	
	# Add light to manager
	if LightManager:
		LightManager.add_light(light_amount)
	
	# Burst effect
	particles.emitting = true
	
	# Fade out and remove
	var tween = create_tween()
	tween.tween_property(sprite, "modulate:a", 0.0, 0.5)
	tween.tween_callback(queue_free)
