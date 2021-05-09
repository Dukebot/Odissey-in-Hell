class_name CombatState extends Node

var fight_current_turn = 0
var fight_current_enemy = {}

var player
var skills

onready var main = get_parent()


func init():
	player = main.player
	skills = main.skills


func process_state() -> void:
	print("I am on combat state")
	if fight_current_turn == 0:
		print("Player attacks")
		
		var text = "Select your attack:"
		for skill in player["skills"]:
			text += "\n" + skill
		main.show_message(text)
		
		var skill_key
		
		if Input.is_action_just_pressed("skill_1"):
			skill_key = player["skills"][0]
		elif Input.is_action_just_pressed("skill_2"):
			skill_key = player["skills"][1]
		elif Input.is_action_just_pressed("skill_3"):
			skill_key = player["skills"][2]
		
		if skill_key:
			var skill = skills[skill_key]
			fight_current_enemy["healh"] = fight_current_enemy["health"] - player["strength"] + skill["power"] - fight_current_enemy["defense"]
	else:
		print("Enemy turn...")
		var enemy_skill_keys = fight_current_enemy["skills"]
		var rand_skill_index = Utils.get_random_array_index(enemy_skill_keys)
		var skill_key = enemy_skill_keys[rand_skill_index]
		var skill = skills[skill_key]
		
		player["healh"] = player["health"] - fight_current_enemy["strength"] + skill["power"] - player["defense"]
		pass
