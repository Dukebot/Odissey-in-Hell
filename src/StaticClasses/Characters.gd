class_name Character extends Node


static func calculate_attack_damage(character: Dictionary, skill: Dictionary, items: Dictionary) -> int:
	var strength_base = character["strength"]
	var skill_power = skill["power"]
	
	var weapon_strength = 0
	if character.has("weapon") and character["weapon"] != "":
		var weapon = items[character["weapon"]]
		weapon_strength = weapon["strength"]
	
	return strength_base + weapon_strength + skill_power


static func calculate_defence(character: Dictionary, items: Dictionary) -> int:
	var defence_base = character["defence"]
	
	var armor_defence = 0
	if character.has("armor") and character["armor"] != "":
		var armor_key = character["armor"]
		print(armor_key)
		var armor = items[armor_key]
		armor_defence = armor["defence"]
	
	return defence_base + armor_defence


static func add_ailment_state(character: Dictionary, status_ailment: String) -> bool:
	var ailmend_status_added: bool = false
	if not has_status_ailment(character, status_ailment):
		character["status_ailment"].append(status_ailment)
		ailmend_status_added = true
	return ailmend_status_added


static func remove_status_ailment(character: Dictionary, status_ailment: String) -> void:
	var status_ailments = []
	for i in character["status_ailment"].size():
		var current_status_ailment = character["status_ailment"][i]
		if current_status_ailment != status_ailment:
			status_ailments.append(current_status_ailment)
	character["status_ailment"] = status_ailments


static func has_status_ailment(character: Dictionary, status_ailment: String) -> bool:
	var has_ailment := false
	for _status_ailment in character["status_ailment"]:
		if _status_ailment == status_ailment:
			has_ailment = true
			break
	return has_ailment
