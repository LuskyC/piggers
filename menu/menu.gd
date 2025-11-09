extends CanvasLayer



func _on_start_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file('res://main map/main_map.tscn')
	





func _on_exit_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
