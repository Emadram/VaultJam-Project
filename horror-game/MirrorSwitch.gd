extends Area2D

signal activated
signal deactivated

@onready var sprite = $Sprite2D
@export var only_doppelganger: bool = true

var is_pressed: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	# Set color to red to hint it's for Doppelganger
	if sprite:
		sprite.modulate = Color(1.0, 0.4, 0.4, 1.0) 

func _on_body_entered(body: Node2D) -> void:
	if only_doppelganger and not body.name.contains("Doppelganger"):
		return
	if not only_doppelganger and not (body.name.contains("Player") or body.name.contains("Doppelganger")):
		return
		
	if not is_pressed:
		is_pressed = true
		activated.emit()
		_visual_press()

func _on_body_exited(body: Node2D) -> void:
	if only_doppelganger and not body.name.contains("Doppelganger"):
		return
	if not only_doppelganger and not (body.name.contains("Player") or body.name.contains("Doppelganger")):
		return
		
	# Check if overlapping bodies still exist? 
	# For simplicity, if any valid body exits, we check overlaps.
	if not has_overlapping_valid_bodies():
		is_pressed = false
		deactivated.emit()
		_visual_release()

func has_overlapping_valid_bodies() -> bool:
	for body in get_overlapping_bodies():
		if only_doppelganger:
			if body.name.contains("Doppelganger"): return true
		else:
			if body.name.contains("Player") or body.name.contains("Doppelganger"): return true
	return false

func _visual_press() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.2, 0.8), 0.1)
	tween.tween_property(sprite, "modulate:a", 1.0, 0.1) # Brighten

func _visual_release() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)
	tween.tween_property(sprite, "modulate:a", 0.6, 0.1) # Dim
