extends Node

var prev_scene

func change_scene(path: String):
	prev_scene = get_tree().current_scene.scene_file_path
	get_tree().change_scene_to_file(path)

func to_settings():
	change_scene("res://settings/settings.tscn")

func to_dress():
	change_scene("res://dress/dress.tscn")
	
func to_saves():
	change_scene("res://saves/saves.tscn")
