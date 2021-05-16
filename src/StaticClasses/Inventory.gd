class_name Inventory extends Node

#Caramels...

static func get_use_caramel_message(inventory: Dictionary, player: Dictionary) -> String:
	var message = ""
	if inventory["caramels"] > 0:
		if player["health"] < player["max_health"]:
			message = "Do you want to use a Caramel?"
		else:
			message = "You are full health"
	else:
		message = "You don't have any Caramels"
	return message


static func can_use_caramel(inventory: Dictionary, player: Dictionary) -> bool:
	if inventory["caramels"] > 0:
		if player["health"] < player["max_health"]:
			return true
	return false


static func use_caramel(inventory: Dictionary, player: Dictionary) -> String:
	player["health"] += 10
	inventory["caramels"] -= 1
	return "You use a Caramel and heal 10 points of life"


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
	return "You use an Antidote and heal the poison"
