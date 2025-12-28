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
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	current_duration = initial_duration
	checkpoint_position = global_position
	# Connection is defined in Fire.tscn; avoid double-connecting here.
	
	# Start with fire lit
	light_fire()

func light_fire() -> void:
	is_lit = true
	timer.start(current_duration)
	sprite.play("burn")
	
	# Visual feedback - Amber Glow #FFAC2E
	sprite.modulate = Color("#FFAC2E")

func extinguish_fire() -> void:
	if not is_lit:
		return
	
	is_lit = false
	timer.stop()
	sprite.stop()
	
	# Visual feedback - Cool Slate mid-tone #2D344B
	sprite.modulate = Color("#2D344B")
	sprite.modulate.a = 0.5
	
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

func _process(_delta: float) -> void:
	if is_lit:
		_apply_flicker()

func _apply_flicker() -> void:
	var time_left = get_time_remaining()
	var ratio = 1.0 - (time_left / current_duration)
	
	# Scale animation down as time runs out (from 1.0 to 0.4)
	var base_scale = lerp(1.0, 0.4, ratio)
	
	# Subtle flicker on top of the base scale
	var pulse_speed = 10.0 + (ratio * 10.0)
	var pulse_intensity = 0.02 + (ratio * 0.08)
	var pulse = 1.0 + (sin(Time.get_ticks_msec() * 0.001 * pulse_speed) * pulse_intensity)
	
	sprite.scale = Vector2(base_scale, base_scale) * pulse
	
	# Correlate animation speed with time remaining
	sprite.speed_scale = lerp(1.2, 0.6, ratio)
	
	# Shift from bright yellow to deep amber
	var fire_color = Color("#FFE082").lerp(Color("#FF4E24"), ratio)
	sprite.modulate = fire_color
	sprite.modulate.a = lerp(1.0, 0.9, ratio)

func _on_timer_timeout() -> void:
	extinguish_fire()
