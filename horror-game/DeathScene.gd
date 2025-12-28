extends Control

@onready var background = $Background
@onready var death_message = $DeathMessage
@onready var death_count_label = $DeathMessage/DeathCount
@onready var reason_label = $DeathMessage/Reason
@onready var hint_label = $DeathMessage/Hint

var death_reason: String = "The darkness claimed you."
var death_count: int = 1

func _ready() -> void:
	# Get death info from GameManager
	death_count = GameManager.get_level_death_count()
	
	# Update labels
	death_count_label.text = "Death #%d" % death_count
	reason_label.text = death_reason
	
	# Contextual hints based on death count
	if death_count == 1:
		hint_label.text = "Stay in the light. Memorize the puzzle symbols before darkness falls."
	elif death_count == 2:
		hint_label.text = "Running makes noise and attracts the monster. Walk carefully in darkness."
	elif death_count == 3:
		hint_label.text = "Use fire checkpoints strategically. Don't let them expire too soon."
	elif death_count >= 4:
		hint_label.text = "The monster patrols when lit. Track its position before the fire dies."
	
	# Animate using Tweens
	_play_death_animation()

func _play_death_animation() -> void:
	# Background fade to red
	var bg_tween = create_tween()
	bg_tween.tween_property(background, "modulate", Color(0.3, 0, 0, 1), 2.0)
	
	# Message fade in
	await get_tree().create_timer(0.5).timeout
	var msg_tween = create_tween()
	msg_tween.tween_property(death_message, "modulate", Color(1, 1, 1, 1), 1.5)
	
	await msg_tween.finished
	await get_tree().create_timer(2.0).timeout
	
	# Return to level
	GameManager.restart_current_level()

func set_death_reason(reason: String) -> void:
	death_reason = reason
