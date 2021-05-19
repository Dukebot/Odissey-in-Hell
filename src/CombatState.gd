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
	
	#PreAction Phase
	if turn_phase == 0:
		var status_ailments = player["status_ailment"]
		if status_ailments.size() > 0:
			for status_ailment in status_ailments:
				if status_ailment == "poison":
					messages.append(Character.apply_poison(player))
		turn_phase += 1
	#Action Phase
	elif turn_phase == 1:
		if Character.has_status_ailment(player, "stun"):
			Character.remove_status_ailment(player, "stun")
			messages.append(player["name"] + " is stunned and can't act this turn")
			turn = 1
			turn_phase = 0
		elif Character.has_status_ailment(player, "confusion"):
			if player["confusion_turns"] > 0:
				player["confusion_turns"] -= 1
				if player["confusion_turns"] == 0:
					Character.remove_status_ailment(player, "confusion")
				if rand_range(0, 1) < 0.33:
					messages.append(player["name"] + " is confused and can't attack this turn")
					turn = 1
					turn_phase = 0
				else:
					player_action_selection()
		else:
			player_action_selection()
	#Action resolution and turn switch phase
	elif turn_phase == 2:
		if enemy["health"] < 0:
			main.map[enemy_x][enemy_y] = " "
			main.inventory["caramels"] += 1
			main.set_move_state()
			main.show_message("The " + enemy["name"] + " dropped a Caramel)
		else:
			turn = 1
			turn_phase = 0


func player_action_selection():
	show_attack_selection()
	var skill_key = get_skill_selection()
	if skill_key:
		attack(main.player, main.skills[skill_key], enemy)
	var item_key = get_item_selection()
	if item_key:
		use_item(item_key)


func show_attack_selection():
	var text = "Select your attack:"
	var i = 0
	for skill in main.player["skills"]:
		i += 1
		text += "\n" + str(i) + " - " + skill
	main.show_message(text)


func get_skill_selection():
	var skill_key
	if Input.is_action_just_pressed("skill_1"):
		skill_key = main.player["skills"][0]
	elif Input.is_action_just_pressed("skill_2"):
		skill_key = main.player["skills"][1]
	elif Input.is_action_just_pressed("skill_3"):
		skill_key = main.player["skills"][2]
	return skill_key


func get_item_selection():
	var item_key
	if Input.is_action_just_pressed("use_caramel"):
		item_key = "caramels"
	elif Input.is_action_just_pressed("use_antidote"):
		item_key = "antidotes"
	return item_key


func enemy_turn():
	if turn_phase == 0:
		var enemy_skill_keys = enemy["skills"]
		var rand_skill_index = Utils.get_random_array_index(enemy_skill_keys)
		var skill_key = enemy_skill_keys[rand_skill_index]
		var skill = main.skills[skill_key]
		
		if skill_key == "heal":
			var healing_points = skill["power"]
			enemy["health"] += healing_points
			if enemy["health"] > enemy["max_health"]:
				var difference = enemy["health"] - enemy["max_health"]
				healing_points -= difference
				enemy["health"] = enemy["max_health"]
			messages.append(enemy["name"] + " healed " + str(healing_points))
		else:
			attack(enemy, skill, main.player)
	elif turn_phase == 1:
		if main.player["health"] < 0:
			print("Game Over...")
			main.set_move_state()
			main.show_message("You've been defeated...")
		else:
			turn = 0
			turn_phase = 0


func attack(attacker: Dictionary, skill: Dictionary, target: Dictionary):
	var damage = Character.calculate_attack_damage(attacker, skill, main.items)
	if not skill["is_magic"]:
		#damage -= Character.calculate_defence(target, main.items)
		damage = int(damage * (100/(100 + Character.calculate_defence(target, main.items))))
	if damage < 0: 
		damage = 0
	
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
	
	turn_phase += 1


func use_item(item_key: String) -> void:
	var inventory = main.inventory
	var player = main.player
	
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
