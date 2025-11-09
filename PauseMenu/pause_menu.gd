extends Control

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if visible:
			hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_resume_pressed():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_quit_pressed():
	get_tree().change_scene_to_file("res://menu/menu.tscn")

func _on_multiplayer_pressed():
	pass
