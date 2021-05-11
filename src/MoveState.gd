class_name MoveState extends Node

var player_x: int
var player_y: int

onready var main = get_parent()


func init():
	var map = main.map
	for i in map.size():
		for j in map[i].size():
			if map[i][j] == "P":
				player_x = i
				player_y = j


func process_state() -> void:
	if Input.is_action_just_pressed("move_up"):
		move(player_x - 1, player_y)
	elif Input.is_action_just_pressed("move_down"):
		move(player_x + 1, player_y)
	elif Input.is_action_just_pressed("move_left"):
		move(player_x, player_y - 1)
	elif Input.is_action_just_pressed("move_right"):
		move(player_x, player_y + 1)


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
			main.set_use_item_state("axes", x, y)
		else:
			show_message("You need an Ax to destroy a Barred Door")

	elif map[x][y] == "W":
		if inventory["explosives"] > 0:
			show_message("Do you want to use an Explosive to destroy the Cracked Wall?\n\nY/N")
			main.set_use_item_state("explosives", x, y)
		else:
			show_message("You need an Explosive to destroy a Cracked Wall")
	
	#Enemy combat
	elif map[x][y] == "L":
		#show_message("TODO combat with enemy")
		#map[x][y] = " "
		main.set_combat_state("lesser_demon", x, y)
	
	elif map[x][y] == "S":
		show_message("TODO combat with enemy")
		map[x][y] = " "
	
	elif map[x][y] == "H":
		show_message("TODO combat with enemy")
		map[x][y] = " "
	
	elif map[x][y] == "G":
		show_message("TODO combat with enemy")
		map[x][y] = " "


func set_player_pos(x: int, y: int) -> void:
	var map = main.map
	map[player_x][player_y] = " "
	map[x][y] = "P"
	player_x = x
	player_y = y


func show_message(text: String) -> void:
	main.show_message(text)
