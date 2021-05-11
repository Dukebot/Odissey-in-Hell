class_name UseItemState extends Node

var item: String = ""
var item_x: int
var item_y: int

onready var main = get_parent()


func process_state() -> void:
	if Input.is_action_just_pressed("yes"):
		var inventory = main.inventory
		var map = main.map
		
		inventory[item] -= 1
		
		if map[item_x][item_y] == "B":
			map[item_x][item_y] = " "
			main.show_message("You destroy the Barred Door with your Ax")
		
		elif map[item_x][item_y] == "W":
			map[item_x][item_y] = " "
			main.show_message("You destroy the Cracked Wall with your Explosive")
		
		main.set_move_state()
	
	elif Input.is_action_just_pressed("no"):
		main.show_message("")
		main.set_move_state()


func set_state(item: String, item_x: int, item_y: int):
	self.item = item
	self.item_x = item_x
	self.item_y = item_y

