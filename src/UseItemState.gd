class_name UseItemState extends Node

var use_item: String = ""
var use_item_x: int
var use_item_y: int

var map
var inventory

onready var main = get_parent()


func init():
	map = main.map
	inventory = main.inventory


func process_state() -> void:
	if Input.is_action_just_pressed("yes"):
		inventory[use_item] -= 1
		
		if map[use_item_x][use_item_y] == "B":
			map[use_item_x][use_item_y] = " "
			main.show_message("You destroy the Barred Door with your Ax")
		
		elif map[use_item_x][use_item_y] == "W":
			map[use_item_x][use_item_y] = " "
			main.show_message("You destroy the Cracked Wall with your Explosive")
		
		main.set_move_state()
	
	elif Input.is_action_just_pressed("no"):
		main.show_message("")
		main.set_move_state()
