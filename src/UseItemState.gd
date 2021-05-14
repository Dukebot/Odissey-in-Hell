class_name UseItemState extends Node

var item: String = ""
var item_x: int
var item_y: int

onready var main = get_parent()


func process_state() -> void:
	if Input.is_action_just_pressed("yes"):
		var map = main.map
		var player = main.player
		
		if item == "caramels":
			player["health"] += 10
			main.show_message("You use a Caramel and heal an amount")
		
		elif item == "antidotes":
			Character.remove_status_ailment(player, "poison")
			main.show_message("You use an Antidote and heal the poison")
		
		elif map[item_x][item_y] == "B":
			map[item_x][item_y] = " "
			main.show_message("You destroy the Barred Door with your Ax")
		
		elif map[item_x][item_y] == "W":
			map[item_x][item_y] = " "
			main.show_message("You destroy the Cracked Wall with your Explosive")
		
		main.inventory[item] -= 1
		main.set_move_state()
	
	elif Input.is_action_just_pressed("no"):
		main.show_message("")
		main.set_move_state()


func set_state(item: String, item_x: int, item_y: int):
	self.item = item
	self.item_x = item_x
	self.item_y = item_y
