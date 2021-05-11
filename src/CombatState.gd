class_name CombatState extends Node

var turn = 0
var enemy = {}
var enemy_x
var enemy_y

var last_attack_result_text: String = ""

onready var main = get_parent()


func process_state():
	var player = main.player
	var skills = main.skills
	var map = main.map
	
	if turn == 0:
		show_player_attack_selection()
		turn = 1
	
	elif turn == 1:
		var skill_key = get_player_skill_selection()
		if skill_key:
			attack(player, skill_key, enemy)
			turn = 2
	
	elif turn == 2:
		main.show_message(last_attack_result_text)
		if Input.is_action_just_pressed("continue"):
			if map[enemy_x][enemy_y] == " ":
				main.set_move_state()
			else:
				turn = 3

	elif turn == 3:
		var enemy_skill_keys = enemy["skills"]
		var rand_skill_index = Utils.get_random_array_index(enemy_skill_keys)
		var skill_key = enemy_skill_keys[rand_skill_index]
		attack(enemy, skill_key, player)
		turn = 4
	
	elif turn == 4:
		main.show_message(last_attack_result_text)
		if Input.is_action_just_pressed("continue"):
			turn = 0


func show_player_attack_selection():
	var player = main.player
	
	var text = "Select your attack:"
	var i = 0
	for skill in player["skills"]:
		i += 1
		text += "\n" + str(i) + " - " + skill
	
	main.show_message(text)


func get_player_skill_selection():
	var player = main.player
	
	var skill_key
	if Input.is_action_just_pressed("skill_1"):
		skill_key = player["skills"][0]
	elif Input.is_action_just_pressed("skill_2"):
		skill_key = player["skills"][1]
	elif Input.is_action_just_pressed("skill_3"):
		skill_key = player["skills"][2]
	
	return skill_key


func attack(attacker: Dictionary, skill_key: String, target: Dictionary):
	var skills = main.skills
	var skill = skills[skill_key]
	var damage = attacker["strength"] + skill["power"] - target["defence"]
	
	if rand_range(0, 1) < skill["accuracy"]:
		target["health"] = target["health"] - damage
		last_attack_result_text = attacker["name"] + " used " + skill["name"] + " and inflicted " + str(damage) + " of damage"
	else:
		last_attack_result_text = attacker["name"] + " used " + skill["name"] + " and missed!"
	
	if target["health"] < 0:
		if target["name"] == "Player":
			print("Game Over...")
		else:
			var map = main.map
			map[enemy_x][enemy_y] = " "
