class_name CombatState extends Node

var turn: int = 0
var turn_phase: int = 0

var enemy: Dictionary = {}
var enemy_x: int
var enemy_y: int

var messages: Array = []
var messages_index: int = 0

onready var main = get_parent()


func _ready():
	randomize()


func process_state():
	if messages.size() > 0:
		main.show_message(messages[messages_index])
		if Input.is_action_just_pressed("continue"):
			messages_index += 1
			if messages_index >= messages.size():
				messages = []
				messages_index = 0
				print("Los mensajes se han vaciado")
	else:
		if turn == 0:
			player_turn()
		elif turn == 1:
			enemy_turn()


func set_state(enemy: Dictionary, enemy_x: int, enemy_y: int):
	turn = 0
	turn_phase = 0
	messages = []
	messages_index = 0
	self.enemy = enemy.duplicate()
	self.enemy_x = enemy_x
	self.enemy_y = enemy_y
	messages.append("You've found a " + enemy["name"])


func player_turn():
	var player = main.player
	var map = main.map
	var inventory = main.inventory
	
	if turn_phase == 0:
		status_ailment_phase(player)
		turn_phase += 1
	elif turn_phase == 1:
		if Character.has_status_ailment(player, "stun"):
			Character.remove_status_ailment(player, "stun")
			turn = 1
			turn_phase = 0
		else:
			show_attack_selection(player)

			var skill_key = get_skill_selection(player)
			if skill_key:
				print("Usamos un ataque")
				attack(player, skill_key, enemy)
				turn_phase += 1
			
			var item_key = get_item_selection()
			if item_key:
				#Item usage
				print("Usamos un objeto")
				if item_key == "caramels":
					var message = Inventory.get_use_caramel_message(inventory, player)
					if Inventory.can_use_caramel(inventory, player):
						messages.append(Inventory.use_caramel(inventory, player))
						turn_phase += 1
					else:
						messages.append(message)
				elif item_key == "antidotes":
					var message = Inventory.get_use_antidote_message(inventory, player)
					if Inventory.can_use_antidote(inventory, player):
						messages.append(Inventory.use_antidote(inventory, player))
						turn_phase += 1
					else:
						messages.append(message)
	elif turn_phase == 2:
		if enemy["health"] < 0:
			map[enemy_x][enemy_y] = " "
			main.set_move_state()
			main.show_message("You defeated the " + enemy["name"])
		else:
			turn = 1
			turn_phase = 0


func status_ailment_phase(character: Dictionary):
	var status_ailments = character["status_ailment"]
	if status_ailments.size() > 0:
		for status_ailment in status_ailments:
			if status_ailment == "poison":
				character["health"] -= 5
				messages.append("The poison lowers " + character["name"] + "'s health by 5 points")
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


func get_item_selection():
	var item_key
	if Input.is_action_just_pressed("use_caramel"):
		item_key = "caramels"
	elif Input.is_action_just_pressed("use_antidote"):
		item_key = "antidotes"
	return item_key


func enemy_turn():
	var player = main.player
	
	if turn_phase == 0:
		var enemy_skill_keys = enemy["skills"]
		var rand_skill_index = Utils.get_random_array_index(enemy_skill_keys)
		var skill_key = enemy_skill_keys[rand_skill_index]
		attack(enemy, skill_key, player)
		turn_phase += 1
	elif turn_phase == 1:
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
		messages.append(
			attacker["name"] + " used " + skill["name"] + " and inflicted " + str(damage) + " of damage"
		)
		if skill["effect"] and skill["effect"] != "":
			if Character.add_ailment_state(target, skill["effect"]):
				messages.append(skill["effect"] + " status ailment added.")
	else:
		messages.append(attacker["name"] + " used " + skill["name"] + " and missed!")
