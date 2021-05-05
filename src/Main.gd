extends Control

enum GameState {MOVE, USE_ITEM, COMBAT}

var game_state = GameState.MOVE

var player_x: int
var player_y: int

var use_item: String = ""
var use_item_x: int
var use_item_y: int

var fight_current_turn = 0
var fight_current_enemy = {}

onready var game_data = $GameData

onready var map_label = $MapLabel
onready var text_output_label = $TextOutput

onready var map = game_data.map
onready var inventory = game_data.inventory
onready var characters = game_data.characters
onready var skills = game_data.skills

onready var player = characters["player"]


func _ready():
	draw_map()
	init_player_position()


func draw_map():
	map_label.text = ""
	for i in map.size():
		for j in map[i].size():
			map_label.text += map[i][j]
			if j == map.size() - 1:
				map_label.text += "\n"
	
	var inventory_items_label = $InventoryItems
	inventory_items_label.text = ""
	for key in inventory.keys():
		inventory_items_label.text += key + " - " + str(inventory[key]) + "\n"


func init_player_position():
	for i in map.size():
		for j in map[i].size():
			if map[i][j] == "P":
				player_x = i
				player_y = j


func _process(delta):
	if game_state == GameState.MOVE:
		move_state()
	elif game_state == GameState.USE_ITEM:
		use_item_state()
	elif game_state == GameState.COMBAT:
		combat_state()


func move_state():
	if Input.is_action_just_pressed("move_up"):
		move(player_x - 1, player_y)
	elif Input.is_action_just_pressed("move_down"):
		move(player_x + 1, player_y)
	elif Input.is_action_just_pressed("move_left"):
		move(player_x, player_y - 1)
	elif Input.is_action_just_pressed("move_right"):
		move(player_x, player_y + 1)


func use_item_state():
	if Input.is_action_just_pressed("yes"):
		inventory[use_item] -= 1
		
		if map[use_item_x][use_item_y] == "B":
			map[use_item_x][use_item_y] = " "
			show_message("You destroy the Barred Door with your Ax")
		
		elif map[use_item_x][use_item_y] == "W":
			map[use_item_x][use_item_y] = " "
			show_message("You destroy the Cracked Wall with your Explosive")
		
		game_state = GameState.MOVE
		draw_map()
	
	elif Input.is_action_just_pressed("no"):
		show_message("")
		game_state = GameState.MOVE


func combat_state():
	if fight_current_turn == 0:
		var text = "Select your attack:"
		for skill in player["skills"]:
			text += "\n" + skill
		show_message(text)
		if Input.is_action_just_pressed("skill_1"):
			pass
		elif Input.is_action_just_pressed("skill_2"):
			pass
		elif Input.is_action_just_pressed("skill_3"):
			pass
	else:
		print("Enemy turn...")
		var enemy_skill_keys = fight_current_enemy["skills"]
		var rand_skill_index = Utils.get_random_array_index(enemy_skill_keys)
		var skill_key = enemy_skill_keys[rand_skill_index]
		var skill = skills[skill_key]
		pass


func move(x, y):
	#Basic Movement
	if map[x][y] == "#":
		show_message("You smash your face against a wall")
	elif map[x][y] == " ":
		set_player_pos(x, y)
		show_message("")
	
	#Grab item movement
	elif map[x][y] == "X":
		inventory["axes"] += 1
		map[x][y] = " "
		show_message("You've found an Ax")
	
	elif map[x][y] == "A":
		inventory["antidotes"] += 1
		map[x][y] = " "
		show_message("You've found an Antidote")
	
	elif map[x][y] == "C":
		inventory["caramels"] += 1
		map[x][y] = " "
		show_message("You've found a Caramel")
	
	elif map[x][y] == "E":
		inventory["explosives"] += 1
		map[x][y] = " "
		show_message("You've found an Explosive")
	
	elif map[x][y] == "M":
		player["weapon"] = "masamune"
		map[x][y] = " "
		show_message("You've found the Masamune!")
	
	elif map[x][y] == "O":
		player["armor"] = "onyx_armor"
		map[x][y] = " "
		show_message("You've found the Onyx Armor!")
	
	elif map[x][y] == "N":
		player["weapon"] = "necronomicon"
		map[x][y] = " "
		show_message("You've found the Necronomicon!")
	
	#Use item
	elif map[x][y] == "B":
		if inventory["axes"] > 0:
			show_message("Do you want to use an Ax to destroy the Barred Door?\n\nY/N")
			set_use_item_state("axes", x, y)
		else:
			show_message("You need an Ax to destroy a Barred Door")

	elif map[x][y] == "W":
		if inventory["explosives"] > 0:
			show_message("Do you want to use an Explosive to destroy the Cracked Wall?\n\nY/N")
			set_use_item_state("explosives", x, y)
		else:
			show_message("You need an Explosive to destroy a Cracked Wall")
	
	#Enemy combat
	elif map[x][y] == "L":
		show_message("TODO combat with enemy")
		map[x][y] = " "
	
	elif map[x][y] == "S":
		show_message("TODO combat with enemy")
		map[x][y] = " "
	
	elif map[x][y] == "H":
		show_message("TODO combat with enemy")
		map[x][y] = " "
	
	elif map[x][y] == "G":
		show_message("TODO combat with enemy")
		map[x][y] = " "
	
	draw_map()


func set_player_pos(x: int, y: int) -> void:
	map[player_x][player_y] = " "
	map[x][y] = "P"
	player_x = x
	player_y = y


func set_use_item_state(item_name: String, target_x: int, target_y: int) -> void:
	game_state = GameState.USE_ITEM
	use_item = item_name
	use_item_x = target_x
	use_item_y = target_y


func set_combat_state(enemy_key: String):
	game_state = GameState.USE_ITEM
	fight_current_enemy = 0
	fight_current_enemy = characters[enemy_key].duplicate()


func show_message(text: String) -> void:
	text_output_label.text = text
