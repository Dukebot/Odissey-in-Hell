class_name CombatState extends Node

var turn: int = 0
var turn_phase: int = 0

var enemy: Dictionary = {}
var enemy_x: int
var enemy_y: int

var combat_started := false

var messages: Array = []
var messages_index: int = 0

onready var main = get_parent()


func process_state():
	if not combat_started:
		main.show_message("You've found a " + enemy["name"])
		if Input.is_action_just_pressed("continue"):
			combat_started = true
	else:
		if turn == 0:
			player_turn()
		elif turn == 1:
			enemy_turn()


func set_state(enemy: Dictionary, enemy_x: int, enemy_y: int):
	turn = 0
	turn_phase = 0
	combat_started = false
	self.enemy = enemy.duplicate()
	self.enemy_x = enemy_x
	self.enemy_y = enemy_y


func player_turn():
	var player = main.player
	var map = main.map
	
	if turn_phase == 0:
		status_ailment_phase(player)
		turn_phase += 1
	
	elif turn_phase == 1:
		if messages.size() > 0:
			main.show_message(messages[messages_index])
			if Input.is_action_just_pressed("continue"):
				messages_index += 1
				if messages_index == messages.size():
					turn_phase += 1
		else:
			turn_phase += 1
	
	elif turn_phase == 2:
		if Character.has_status_ailment(player, "stun"):
			Character.remove_status_ailment(player, "stun")
			turn = 1
			turn_phase = 0
		else:
			show_attack_selection(player)
			turn_phase += 1
	
	elif turn_phase == 3:
		var skill_key = get_skill_selection(player)
		if skill_key:
			attack(player, skill_key, enemy)
			turn_phase += 1
	
	elif turn_phase == 4:
		
		if messages.size() > 0:
			main.show_message(messages[messages_index])
			if Input.is_action_just_pressed("continue"):
				messages_index += 1
				if messages_index == messages.size():
					if enemy["health"] < 0:
						map[enemy_x][enemy_y] = " "
						main.set_move_state()
						main.show_message("You've defeated " + enemy["name"])
					else:
						turn = 1
						turn_phase = 0


func status_ailment_phase(character: Dictionary):
	var status_ailments = character["status_ailment"]
	messages = []
	messages_index = 0
	
	if status_ailments.size() > 0:
		for status_ailment in status_ailments:
			if status_ailment == "poison":
				character["health"] -= 5
				messages.append("The poison inficts, 5 damage to " + character["name"])
			elif status_ailment == "stun":
				messages.append("You are stunned and can't act this turn.")


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
		if messages.size() > 0:
			main.show_message(messages[messages_index])
			if Input.is_action_just_pressed("continue"):
				messages_index += 1
				if messages_index == messages.size():
					if player["health"] < 0:
						print("Game Over...")
						main.set_move_state()
						main.show_message("You've been defeated...")
					else:
						turn = 0
						turn_phase = 0


func attack(attacker: Dictionary, skill_key: String, target: Dictionary):
	var skill = main.skills[skill_key]
	var items = main.items
	messages = []
	messages_index = 0
	
	var damage = Character.calculate_attack_damage(attacker, skill, items)
	if not skill["is_magic"]:
		damage -= Character.calculate_defence(target, items)
	
	if rand_range(0, 1) < skill["accuracy"]:
		target["health"] = target["health"] - damage
		messages.append(
			attacker["name"] + " used " + skill["name"] + " and inflicted " + str(damage) + " of damage"
		)
		if skill["effect"] and skill["effect"] != "":
			if Character.add_ailment_state(target, skill["effect"]):
				messages.append(skill["effect"] + " status ailment added.")
	else:
		messages.append(attacker["name"] + " used " + skill["name"] + " and missed!")


func set_attack_result_text():
	pass
