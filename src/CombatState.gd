class_name CombatState extends Node

var turn: int = 0
var turn_phase: int = 0

var enemy: Dictionary = {}
var enemy_x: int
var enemy_y: int

var combat_started := false

var last_attack_result_text: String = ""

var status_ailment_messages: Array = []
var status_ailment_messages_index: int = 0

onready var main = get_parent()


func process_state():
	if not combat_started:
		main.show_message("You've found a " + enemy["name"] + "\nPress SPACE to start combat")
		if Input.is_action_just_pressed("continue"):
			combat_started = true
	
	if turn == 0:
		player_turn()
	elif turn == 1:
		enemy_turn()


func set_state(enemy: Dictionary, enemy_x: int, enemy_y: int):
	turn = 0
	turn_phase = 0
	self.enemy = enemy.duplicate()
	self.enemy_x = enemy_x
	self.enemy_y = enemy_y


func player_turn():
	var player = main.player
	var map = main.map
	
	if turn_phase == 0:
		status_ailment_phase(player)
	
	elif turn_phase == 1:
		if status_ailment_messages.size() > 0:
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
				turn = 1
				turn_phase = 0


func status_ailment_phase(character: Dictionary):
	var status_ailments = character["status_ailment"]
	status_ailment_messages = []
	
	if status_ailments.size() > 0:
		for status_ailment in status_ailments:
			if status_ailment == "poison":
				character["health"] -= 5
				status_ailment_messages.append("The poison inficts, 5 damage to " + character["name"])
			elif status_ailment == "stun":
				status_ailment_messages.append("You are stunned and can't act this turn.")
	
	turn_phase += 1


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
				turn = 0
				turn_phase = 0


func attack(attacker: Dictionary, skill_key: String, target: Dictionary):
	var skill = main.skills[skill_key]
	var items = main.items
	
	var damage = Character.calculate_attack_damage(attacker, skill, items)
	if not skill["is_magic"]:
		damage -= Character.calculate_defence(target, items)
	
	if rand_range(0, 1) < skill["accuracy"]:
		target["health"] = target["health"] - damage
		last_attack_result_text = attacker["name"] + " used " + skill["name"] + " and inflicted " + str(damage) + " of damage"
		
		if skill["effect"] != "":
			var ailment_added: bool = Character.add_ailment_state(target, skill["effect"])
			if ailment_added:
				last_attack_result_text += "\n" + skill["effect"] + " status ailment added."
	else:
		last_attack_result_text = attacker["name"] + " used " + skill["name"] + " and missed!"


func set_attack_result_text():
	pass
