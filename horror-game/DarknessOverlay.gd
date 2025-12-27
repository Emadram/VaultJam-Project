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
	
	# Update position and radius (convert world to screen coordinates)
	var screen_pos = get_viewport_transform() * player.global_position
	color_rect.material.set_shader_parameter("player_position", screen_pos)
	color_rect.material.set_shader_parameter("light_radius", light_radius)
