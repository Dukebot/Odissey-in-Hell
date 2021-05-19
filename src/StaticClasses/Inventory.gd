class_name Inventory extends Node


#Caramels...

static func get_use_caramel_message(inventory: Dictionary, player: Dictionary) -> String:
	var message = ""
	if inventory["caramels"] > 0:
		if player["health"] < player["max_health"]:
			message = "Do you want to use a Caramel?"
		else:
			message = "Your are not hurt"
	else:
		message = "You don't have any Caramels"
	return message


static func can_use_caramel(inventory: Dictionary, player: Dictionary) -> bool:
	if inventory["caramels"] > 0:
		if player["health"] < player["max_health"]:
			return true
	return false


static func use_caramel(inventory: Dictionary, player: Dictionary) -> String:
	player["health"] += 35
	inventory["caramels"] -= 1
	return "You eat a Caramel and recover 35 health points"


#Antidotes...

static func get_use_antidote_message(inventory: Dictionary, player: Dictionary) -> String:
	var message
	if inventory["antidotes"] > 0:
		if Character.has_status_ailment(player, "poison"):
			message = "Do you want to use an Antidote?"
		else:
			message = "You are not poisoned"
	else:
		message = "You don't have any Antidotes"
	return message


static func can_use_antidote(inventory: Dictionary, player: Dictionary) -> bool:
	if inventory["antidotes"] > 0:
		if Character.has_status_ailment(player, "poison"):
			return true
	return false


static func use_antidote(inventory: Dictionary, player: Dictionary) -> String:
	Character.remove_status_ailment(player, "poison")
	inventory["antidotes"] -= 1
	return "The Antidote washes the poison off your blood"



#Ax

static func use_ax(inventory: Dictionary, player: Dictionary, map: Array, x: int, y: int) -> String:
	map[x][y] = " "
	inventory["axes"] -= 1
	return "You open the Barred Door with the Ax"


#Explosive

static func use_explosive(inventory: Dictionary, player: Dictionary, map: Array, x: int, y: int) -> String:
	map[x][y] = " "
	inventory["explosives"] -= 1
	return "You destroy the Cracked Wall with the Explosive"
	
