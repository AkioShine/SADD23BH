extends Control

var hovered

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.

func _on_start_pressed() -> void:
	Global.change_scene("res://world.tscn")

func _on_saves_pressed() -> void:
	pass # Replace with function body.

func _on_settings_pressed() -> void:
	Global.to_settings()

func _on_quit_pressed() -> void:
	pass # Replace with function body.
