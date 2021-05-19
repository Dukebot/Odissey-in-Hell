class_name UseItemState extends Node

var item: String = ""
var item_x: int
var item_y: int

onready var main = get_parent()


func process_state() -> void:
	if Input.is_action_just_pressed("yes"):
		var map = main.map
		var player = main.player
		var inventory = main.inventory
		
		if item == "caramels":
			main.show_message(Inventory.use_caramel(inventory, player))
		elif item == "antidotes":
			main.show_message(Inventory.use_antidote(inventory, player))
		elif map[item_x][item_y] == "B":
			main.show_message(Inventory.use_ax(inventory, player, map, item_x, item_y))
		elif map[item_x][item_y] == "W":
			main.show_message(Inventory.use_explosive(inventory, player, map, item_x, item_y))
		
		main.set_move_state()
	
	elif Input.is_action_just_pressed("no"):
		main.show_message("")
		main.set_move_state()


func set_state(item: String, item_x: int, item_y: int):
	self.item = item
	self.item_x = item_x
	self.item_y = item_y
