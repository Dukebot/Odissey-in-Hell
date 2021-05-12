class_name CombatState extends Node

var turn = 0
var turn_phase = 0
var enemy = {}
var enemy_x
var enemy_y

var last_attack_result_text: String = ""

onready var main = get_parent()


func process_state():
	var player = main.player
	var map = main.map
	
	if turn == 0:
		main.show_message("You've found a " + enemy["name"] + "\nPress SPACE to start combat")
		if Input.is_action_just_pressed("continue"):
			turn += 1
	elif turn == 1:
		player_turn()
	elif turn == 2:
		enemy_turn()


func set_state(enemy_key: String, enemy_x: int, enemy_y: int):
	turn = 0
	enemy = main.characters[enemy_key].duplicate()
	self.enemy_x = enemy_x
	self.enemy_y = enemy_y


func player_turn():
	var player = main.player
	var map = main.map
	
	if turn_phase == 0:
		status_ailment_phase(player)
	
	elif turn_phase == 1:
		if Input.is_action_just_pressed("continue"):
			turn_phase += 1
	
	elif turn_phase == 2:
		show_attack_selection(player)
		turn_phase += 1
	
	elif turn_phase == 3:
		var skill_key = get_skill_selection(player) 
		if skill_key:
			attack(player, skill_key, enemy)
			turn_phase += 1
	
	elif turn_phase == 4:
		main.show_message(last_attack_result_text + "\nPress SPACE to continue")
		if Input.is_action_just_pressed("continue"):
			if enemy["health"] < 0:
				map[enemy_x][enemy_y] = " "
				main.set_move_state()
				main.show_message("You've defeated " + enemy["name"])
			else:
				turn = 2
				turn_phase = 0


func status_ailment_phase(character: Dictionary):
	print("Player ailment phase")
	
	var status_ailments = character["status_ailment"]
	
	if status_ailments.size() > 0:
		print("Tengo algun estado alterado")
		if status_ailments[0] == "poison":
			print("Mi estado alterado es veneno")
			character["health"] -= 5
			main.show_message("The poison inficts, 5 damage to " + character["name"])
			turn_phase += 1
	else:
		turn_phase += 2


func show_attack_selection(player: Dictionary):
	var text = "Select your attack:"
	
	var i = 0
	for skill in player["skills"]:
		i += 1
		text += "\n" + str(i) + " - " + skill
	
	main.show_message(text)


func get_skill_selection(player: Dictionary):
	var skill_key
	
	if Input.is_action_just_pressed("skill_1"):
		skill_key = player["skills"][0]
	elif Input.is_action_just_pressed("skill_2"):
		skill_key = player["skills"][1]
	elif Input.is_action_just_pressed("skill_3"):
		skill_key = player["skills"][2]
	
	return skill_key


func enemy_turn():
	var player = main.player
	
	if turn_phase == 0:
		var enemy_skill_keys = enemy["skills"]
		var rand_skill_index = Utils.get_random_array_index(enemy_skill_keys)
		var skill_key = enemy_skill_keys[rand_skill_index]
		attack(enemy, skill_key, player)
		turn_phase += 1
	
	elif turn_phase == 1:
		main.show_message(last_attack_result_text + "\nPress SPACE to continue")
		if Input.is_action_just_pressed("continue"):
			if player["health"] < 0:
				print("Game Over...")
				main.set_move_state()
				main.show_message("You've been defeated...")
			else:
				turn = 1
				turn_phase = 0


func attack(attacker: Dictionary, skill_key: String, target: Dictionary):
	var skill = main.skills[skill_key]
	
	var damage = calculate_attack_strength(attacker, skill)
	if not skill["is_magic"]:
		damage -= calculate_target_defence(target)
	
	if rand_range(0, 1) < skill["accuracy"]:
		target["health"] = target["health"] - damage
		last_attack_result_text = attacker["name"] + " used " + skill["name"] + " and inflicted " + str(damage) + " of damage"
		
		if skill["effect"] != "":
			var status_found := false
			for status_ailment in target["status_ailment"]:
				if status_ailment == skill["effect"]:
					status_found = true
					break
			
			if not status_found:
				target["status_ailment"].append(skill["effect"])
				last_attack_result_text += "\n" + skill["effect"] + " status ailment added."
	else:
		last_attack_result_text = attacker["name"] + " used " + skill["name"] + " and missed!"


func calculate_attack_strength(attacker: Dictionary, skill: Dictionary):
	var strength_base = attacker["strength"]
	
	var weapon_strength = 0
	if attacker.has("weapon") and attacker["weapon"] != "":
		var weapon = main.items[attacker["weapon"]]
		weapon_strength = weapon["strength"]
	
	var skill_power = skill["power"]
	
	return strength_base + weapon_strength + skill_power


func calculate_target_defence(target: Dictionary):
	var defence_base = target["defence"]
	
	var armor_defence = 0
	if target.has("armor") and target["armor"] != "":
		var armor_key = target["armor"]
		print(armor_key)
		var armor = main.items[armor_key]
		armor_defence = armor["defence"]
	
	return defence_base + armor_defence
