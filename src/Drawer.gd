class_name Drawer extends Node


onready var main = get_parent()


func draw() -> void:
	draw_map(main.map_label, main.map)
	draw_player_stats(main.player_stats_label, main.player)
	draw_inventory(main.inventory_items_label, main.inventory)


func draw_map(map_label, map):
	map_label.text = ""
	for i in map.size():
		for j in map[i].size():
			map_label.text += map[i][j]
			if j == map.size() - 1:
				map_label.text += "\n"


func draw_player_stats(player_stats_label, player):
	player_stats_label.text = ""
	#for key in player.keys():
	#	player_stats_label.text += key + " - " + str(player[key]) + "\n"
	player_stats_label.text += "Name: " + player["name"] + "\n"
	player_stats_label.text += "HP: " + str(player["health"])

	


func draw_inventory(inventory_items_label, inventory):
	inventory_items_label.text = ""
	for key in inventory.keys():
		inventory_items_label.text += key + ": " + str(inventory[key]) + "\n"
