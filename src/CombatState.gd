class_name CombatState extends Node

var turn = 0
var enemy = {}
var enemy_x
var enemy_y

onready var main = get_parent()


func process_state():
	_process_state(main.player, main.skills, main.map)


func _process_state(player: Dictionary, skills: Dictionary, map: Dictionary) -> void:
	if turn == 0:
		var text = "Select your attack:"
		for skill in player["skills"]:
			text += "\n" + skill
		main.show_message(text)
		
		var skill_key
		
		if Input.is_action_just_pressed("skill_1"):
			skill_key = player["skills"][0]
		elif Input.is_action_just_pressed("skill_2"):
			skill_key = player["skills"][1]
		elif Input.is_action_just_pressed("skill_3"):
			skill_key = player["skills"][2]
		
		if skill_key:
			var skill = skills[skill_key]
			var damage = player["strength"] + skill["power"] - enemy["defence"]
			print(damage)
			enemy["health"] = enemy["health"] - damage
			turn = 1
			
			if enemy["health"] < 0:
				print("Enemy defeated")
				main.set_move_state()
	
	else:
		print("Enemy turn...")
		var enemy_skill_keys = enemy["skills"]
		var rand_skill_index = Utils.get_random_array_index(enemy_skill_keys)
		var skill_key = enemy_skill_keys[rand_skill_index]
		var skill = skills[skill_key]
		var damage = enemy["strength"] + skill["power"] - player["defence"]
		
		player["health"] = player["health"] - damage
		turn = 0
