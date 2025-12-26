extends CanvasLayer

@export var player_path: NodePath
@export var light_radius: float = 200.0

var player: Node2D
var color_rect: ColorRect

func _ready() -> void:
	# Get player node
	if player_path:
		player = get_node(player_path)
	
	# Get ColorRect child
	color_rect = get_node("ColorRect") as ColorRect
	
	# Set shader parameters
	if color_rect and color_rect.material:
		color_rect.material.set_shader_parameter("light_radius", light_radius)

func _process(delta: float) -> void:
	if not player or not color_rect or not color_rect.material:
		return
	
	# Get player position in screen coordinates (normalized 0-1)
	var viewport_size = get_viewport().get_visible_rect().size
	var player_screen_pos = player.global_position
	
	# Convert to normalized coordinates
	var normalized_pos = player_screen_pos / viewport_size
	
	# Update shader
	color_rect.material.set_shader_parameter("player_position", normalized_pos)
