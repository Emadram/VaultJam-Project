extends Node2D

@onready var player = $Player
@onready var doppelganger = $World/Doppelganger
@onready var hud = $HUD
@onready var gate = $World/ExitGate

var switch_count: int = 0
var required_switches: int = 2

func _ready() -> void:
	if hud:
		hud.show_message("Reflections can be ... deceptive.", 3.0)
	
	# Connect switches
	for child in $World.get_children():
		if child.has_signal("activated"):
			child.activated.connect(_on_switch_activated)
		if child.has_signal("deactivated"):
			child.deactivated.connect(_on_switch_deactivated)
			
	# Init Doppelganger
	# (It runs locally in its _process, no extra init needed)

func _on_boss_trigger_entered(body: Node2D) -> void:
	if body.name == "Player":
		hud.show_message("IT KNOWS.", 3.0)
		hud.flash_warning("RUN!")
		
		# Make Doppelganger Hostile
		if doppelganger:
			doppelganger.become_hostile(player)
			
		# Lock entry? Or just rely on chase.
		# Open final gate slightly? Or requires survival?
		# Let's say: Survive for X seconds?
		# For now: Just Chase.

func _on_switch_activated() -> void:
	switch_count += 1
	_check_victory_condition()

func _on_switch_deactivated() -> void:
	switch_count -= 1

func _check_victory_condition() -> void:
	if switch_count >= required_switches:
		hud.show_message("The path opens...", 2.0)
		hud.flash_warning("EXIT UNLOCKED")
		# Open Gate (Visual)
		var tween = create_tween()
		tween.tween_property($World/ExitGate/ColorRect, "color", Color.GREEN, 0.5)

func _on_exit_body_entered(body: Node2D) -> void:
	if body.name == "Player" and switch_count >= required_switches:
		GameManager.on_level_complete()
	elif body.name == "Player":
		hud.show_message("Locked. Mirrors must be aligned.", 2.0)
