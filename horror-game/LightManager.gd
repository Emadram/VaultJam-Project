extends Node

# Singleton managing global light resource for Level 2 "Last Light"

signal light_changed(percent: float)
signal light_depleted()
signal light_critical(percent: float)  # Emitted at 20%

# Light pool
var current_light: float = 100.0
var max_light: float = 100.0

# Drain rates
@export var base_drain_rate: float = 1.0  # 1% per second
@export var idle_penalty: float = 0.5    # +0.5% per second when not moving
@export var critical_threshold: float = 20.0

# State tracking
var is_player_moving: bool = false
var has_warned_critical: bool = false
var is_near_fire: bool = false  # NEW: Track if player is near fire

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(false) # Don't drain until Level 2 starts

func _process(delta: float) -> void:
	# ONLY DRAIN IF NOT NEAR FIRE
	if not is_near_fire:
		# Calculate drain rate
		var drain = base_drain_rate
		if not is_player_moving:
			drain += idle_penalty
		
		# Drain light
		current_light -= drain * delta
		current_light = max(0.0, current_light)
		
		# Emit signals
		var percent = get_light_percent()
		light_changed.emit(percent)
		
		# Critical warning (once)
		if percent <= critical_threshold and not has_warned_critical:
			has_warned_critical = true
			light_critical.emit(percent)
		
		# Depletion
		if current_light <= 0.0:
			light_depleted.emit()
			set_process(false)  # Stop draining
	else:
		# Near fire, emit signal but don't drain
		light_changed.emit(get_light_percent())

func set_near_fire(near: bool) -> void:
	is_near_fire = near

func set_player_moving(moving: bool) -> void:
	is_player_moving = moving

func add_light(amount: float) -> void:
	current_light = min(max_light, current_light + amount)
	light_changed.emit(get_light_percent())

func consume_light(amount: float) -> bool:
	if current_light >= amount:
		current_light -= amount
		light_changed.emit(get_light_percent())
		return true
	return false

func get_light_percent() -> float:
	return (current_light / max_light) * 100.0

func reset_light() -> void:
	current_light = max_light
	has_warned_critical = false
	set_process(true)
	light_changed.emit(100.0)
