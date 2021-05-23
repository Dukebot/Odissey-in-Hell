extends Control


func _process(delta):
	if Input.is_action_just_pressed("continue"):
		get_tree().change_scene("res://src/Interface/Intro.tscn")
