extends Control


func _process(delta):
	if Input.is_action_just_pressed("continue"):
		get_tree().quit()
