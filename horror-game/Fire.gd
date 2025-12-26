extends Node2D

# Fire checkpoint properties
@export var initial_duration: float = 30.0
@export var duration_decay: float = 5.0  # How much time is lost after death
@export var min_duration: float = 10.0  # Minimum fire duration

# Signals
signal fire_extinguished
signal player_respawned(position: Vector2)

# State
var current_duration: float
var is_lit: bool = false
var checkpoint_position: Vector2

@onready var timer: Timer = $Timer
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	current_duration = initial_duration
	checkpoint_position = global_position
	timer.timeout.connect(_on_timer_timeout)
	
	# Start with fire lit
	light_fire()

func light_fire() -> void:
	is_lit = true
	timer.start(current_duration)
	
	# Visual feedback - full brightness
	sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)

func extinguish_fire() -> void:
	if not is_lit:
		return
	
	is_lit = false
	timer.stop()
	
	# Visual feedback - dimmed
	sprite.modulate = Color(0.3, 0.3, 0.3, 0.5)
	
	# Emit signal
	fire_extinguished.emit()

func reset_player_at_checkpoint(player: Node2D) -> void:
	if player:
		player.global_position = checkpoint_position
		player_respawned.emit(checkpoint_position)
	
	# Decrease duration after death
	current_duration = max(min_duration, current_duration - duration_decay)
	
	# Relight the fire
	light_fire()

func get_time_remaining() -> float:
	return timer.time_left if is_lit else 0.0

func _on_timer_timeout() -> void:
	extinguish_fire()
