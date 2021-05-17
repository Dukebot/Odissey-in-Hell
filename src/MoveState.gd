class_name MoveState extends Node

var player_x: int
var player_y: int

onready var main = get_parent()


func init() -> void:
	var map = main.map
	for i in map.size():
		for j in map[i].size():
			if map[i][j] == "P":
				player_x = i
				player_y = j


func process_state() -> void:
	#Movement
	if Input.is_action_just_pressed("move_up"):
		move(player_x - 1, player_y)
	elif Input.is_action_just_pressed("move_down"):
		move(player_x + 1, player_y)
	elif Input.is_action_just_pressed("move_left"):
		move(player_x, player_y - 1)
	elif Input.is_action_just_pressed("move_right"):
		move(player_x, player_y + 1)
	
	#Inventory Item usage
	var inventory = main.inventory
	var player = main.player
	if Input.is_action_just_pressed("use_caramel"):
		var message = Inventory.get_use_caramel_message(inventory, player)
		if Inventory.can_use_caramel(inventory, player):
			main.set_use_item_state("caramels", player_x, player_y, message)
		else:
			main.show_message(message)
	elif Input.is_action_just_pressed("use_antidote"):
		var message = Inventory.get_use_antidote_message(inventory, player)
		if Inventory.can_use_antidote(inventory, player):
			main.set_use_item_state("antidotes", player_x, player_y, message)
		else:
			main.show_message(message)


func move(x: int, y: int) -> void:
	var map = main.map
	var inventory = main.inventory
	var player = main.player
	
	#Basic Movement
	if map[x][y] == "#":
		show_message("You smash your face against a wall")
	elif map[x][y] == " ":
		set_player_pos(x, y)
		show_message("")
	
	#Grab item
	elif map[x][y] == "X":
		inventory["axes"] += 1
		set_player_pos(x, y)
		show_message("You've found an Ax")
	elif map[x][y] == "A":
		inventory["antidotes"] += 1
		set_player_pos(x, y)
		show_message("You've found an Antidote")
	elif map[x][y] == "C":
		inventory["caramels"] += 1
		set_player_pos(x, y)
		show_message("You've found a Caramel")
	elif map[x][y] == "E":
		inventory["explosives"] += 1
		set_player_pos(x, y)
		show_message("You've found an Explosive")
	elif map[x][y] == "M":
		player["weapon"] = "masamune"
		set_player_pos(x, y)
		show_message("You've found the Masamune!")
	elif map[x][y] == "O":
		player["armor"] = "onyx_armor"
		set_player_pos(x, y)
		show_message("You've found the Onyx Armor!")
	elif map[x][y] == "N":
		player["weapon"] = "necronomicon"
		set_player_pos(x, y)
		show_message("You've found the Necronomicon!")
	
	#Use item
	elif map[x][y] == "B":
		if inventory["axes"] > 0:
			main.set_use_item_state("axes", x, y, "Do you want to use an Ax to open the Barred Door?")
		else:
			show_message("You need an Ax to open a Barred Door")
	elif map[x][y] == "W":
		if inventory["explosives"] > 0:
			main.set_use_item_state("explosives", x, y, "Do you want to use an Explosive to destroy the Cracked Wall?")
		else:
			show_message("You need an Explosive to destroy a Cracked Wall")
	
	#Enemy combat
	elif map[x][y] == "L":
		main.set_combat_state("lesser_demon", x, y)
	elif map[x][y] == "S":
		main.set_combat_state("succubus", x, y)
	elif map[x][y] == "H":
		main.set_combat_state("hell_prision_guard", x, y)
	elif map[x][y] == "G":
		main.set_combat_state("gaahl", x, y)


func set_player_pos(x: int, y: int) -> void:
	main.map[player_x][player_y] = " "
	main.map[x][y] = "P"
	player_x = x
	player_y = y


func show_message(text: String) -> void:
	main.show_message(text)
