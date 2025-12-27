extends Node2D

signal puzzle_solved
signal puzzle_failed(noise_level)

@export var fire_path: NodePath
@export var correct_sequence: Array[int] = [0, 1, 2, 3] # 4-symbol sequence for better challenge

var current_input: Array[int] = []
var fire_node: Node2D
var is_dark: bool = false

@onready var solution_display: Node2D = $SolutionDisplay
@onready var input_buttons: Node2D = $InputButtons
@onready var feedback_label: Label = $FeedbackLabel

func _ready() -> void:
	if fire_path:
		fire_node = get_node(fire_path)
		# Connect to fire signals to toggle state
		if fire_node.has_signal("fire_extinguished"):
			fire_node.fire_extinguished.connect(_on_darkness_start)
		if fire_node.has_signal("player_respawned"): # Fire relits on respawn
			fire_node.player_respawned.connect(_on_light_start)
			# We also need a way to know if fire was simply relit without respawn if that mechanic existed
			# For now assuming fire starts LIT.
	
	_on_light_start(Vector2.ZERO) # Initialize logic as Lit

func _process(delta: float) -> void:
	# Fallback if signals aren't enough or need strict state sync
	if is_instance_valid(fire_node):
		var fire_lit = fire_node.get("is_lit")
		if fire_lit and is_dark:
			_on_light_start(Vector2.ZERO)
		elif not fire_lit and not is_dark:
			_on_darkness_start()

func _on_light_start(_pos) -> void:
	is_dark = false
	solution_display.visible = true
	# input_buttons.visible = false # Optional: hide buttons in light?
	# prompt says "Input done in darkness", so maybe disable interaction
	current_input.clear()
	feedback_label.text = "MEMORIZE..."

func _on_darkness_start() -> void:
	is_dark = true
	solution_display.visible = false
	current_input.clear()
	feedback_label.text = "INPUT CODE..."

func on_button_pressed(button_index: int) -> void:
	if not is_dark:
		feedback_label.text = "TOO BRIGHT!"
		return
		
	current_input.append(button_index)
	feedback_label.text = str(current_input)
	
	# Check if sequence matches so far
	if current_input[current_input.size() - 1] != correct_sequence[current_input.size() - 1]:
		_fail_puzzle()
		return
		
	# Check if complete
	if current_input.size() == correct_sequence.size():
		_solve_puzzle()

func _fail_puzzle() -> void:
	feedback_label.text = "WRONG!"
	current_input.clear()
	# Emit noise to attract monster
	puzzle_failed.emit(1.0) 

func _solve_puzzle() -> void:
	feedback_label.text = "SOLVED!"
	puzzle_solved.emit()
