extends Control

@export var kill_counter = 0

func increase_kill_counter(value: int):
	kill_counter += value
	set_kill_counter(kill_counter)

func set_kill_counter(value: int):
	kill_counter = value
	$KillCounter.text = str(value)

signal resume

func _on_game_area_focus_handler_pressed() -> void:
	emit_signal("resume")

func _on_settings_pressed() -> void:
	Global.to_settings()

func _on_dress_pressed() -> void:
	Global.to_dress()

func _on_music_pressed() -> void:
	pass # Replace with function body.
