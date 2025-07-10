extends AnimatedSprite2D

var time = 0.0
var next_change = 3.0
var next_glitch = true

# Easing parameters
@export var ease_in: float = 100.0  # Higher values = sharper ease in
@export var ease_out: float = 4.0 # Higher values = sharper ease out
@export var max_shake_power: float = 0.05
@export var max_shake_rate: float = 3.0
@export var min_shake_rate: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	var half_change = next_change / 2

	# Calculate normalized progress (0 to 1)
	var progress = time / next_change if next_glitch else 1.0 - (time / next_change)
	
	# Apply easing
	var eased_progress = ease_function(progress, ease_in, ease_out)
	
	if !next_glitch:
		eased_progress = 1
		
	if time > next_change:
		time = 0
		if next_glitch:
			next_change = randf_range(0.1, 0.5)
			if randi_range(0, 1) == 1:
				set_animation("glitch")
		else:
			next_change = randf_range(4.0, 20.0)
			set_animation("default")
		next_glitch = !next_glitch
	
		
	if material is ShaderMaterial:
		material.set_shader_parameter("shake_power", eased_progress * max_shake_power)
		material.set_shader_parameter("shake_rate", randf_range(min_shake_rate, max(min_shake_rate, eased_progress * max_shake_rate)))

# Custom easing function
func ease_function(t: float, ease_in_power: float, ease_out_power: float) -> float:
	# Ease in and out with configurable power
	var ease_in_value = pow(t, ease_in_power)
	var ease_out_value = 1.0 - pow(1.0 - t, ease_out_power)
	return lerp(ease_in_value, ease_out_value, t)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("default")
