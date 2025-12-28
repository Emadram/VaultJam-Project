extends CanvasLayer

@export var player_path: NodePath
@export var light_radius: float = 200.0

var player: Node2D
var color_rect: ColorRect
var fire_nodes: Array[Node2D] = []

func _ready() -> void:
	# Get player node
	if player_path:
		player = get_node(player_path)
	
	# Get ColorRect child
	color_rect = get_node("ColorRect") as ColorRect
	
	# Set shader parameters
	if color_rect and color_rect.material:
		color_rect.material.set_shader_parameter("light_radius", light_radius)
	
	# Find all fire nodes in the scene
	await get_tree().process_frame # Wait for scene to be ready
	_find_fire_nodes()

func _find_fire_nodes() -> void:
	# Search for all Fire instances in the level
	var level = get_parent()
	if level:
		for child in level.get_children():
			if child.name.contains("Fire") and child.has_method("get_time_remaining"):
				fire_nodes.append(child)
	
	print("Found %d fire checkpoints" % fire_nodes.size())

func _process(_delta: float) -> void:
	if not player or not color_rect or not color_rect.material:
		return
	
	# Update player position (convert world to screen coordinates)
	var screen_pos = player.get_global_transform_with_canvas().origin
	color_rect.material.set_shader_parameter("player_position", screen_pos)
	color_rect.material.set_shader_parameter("light_radius", light_radius)
	
	# Update fire positions
	_update_fire_positions()

func _update_fire_positions() -> void:
	var fire_positions: Array[Vector2] = []
	var active_count = 0
	
	for fire in fire_nodes:
		if is_instance_valid(fire) and fire.get("is_lit"):
			# Convert fire world position to screen coordinates
			var fire_screen_pos = fire.get_global_transform_with_canvas().origin
			fire_positions.append(fire_screen_pos)
			active_count += 1
			
			if active_count >= 5: # Max 5 fires in shader
				break
	
	# Pad array to size 5 (shader expects fixed array)
	while fire_positions.size() < 5:
		fire_positions.append(Vector2(-9999, -9999)) # Off-screen position
	
	# Update shader
	color_rect.material.set_shader_parameter("fire_positions", fire_positions)
	color_rect.material.set_shader_parameter("fire_count", active_count)
