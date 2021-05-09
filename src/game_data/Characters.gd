extends Node


func get_data():
	return {
		"player": {
			"name": "player_name",
			"health": 100,
			"strength": 0,
			"magic_power": 0,
			"defence": 0,
			"skills": ["cut", "thrust", "slash", "magic"],
			"effect": "",
			"weapon": "copper_sword",
			"armor": "leather_armor"
		},
		"lesser_demon": {
			"name": "Lesser Demon",
			"health": 50,
			"strength": 5,
			"magic_power": 5,
			"defence": 5,
			"skills": ["spit", "black_magic", "scratch"],
			"effect": "poison",
			"weapon": "",
			"armor": ""
		},
		"succubus": {
			"name": "Succubus",
			"health": 100,
			"strength": 15,
			"magic_power": 20,
			"defence": 10,
			"skills": ["kiss", "knives", "fireball"],
			"effect": "paralysis",
			"weapon": "",
			"armor": ""
		},
		"hell_prision_ward": {
			"name": "Hell Prision Guard",
			"health": 170,
			"strength": 30,
			"magic_power": 45,
			"defence": 20,
			"skills": ["electroshock", "shot", "lightning"],
			"effect": "stun",
			"weapon": "",
			"armor": ""
		},
		"gaahl": {
			"name": "Gaahl",
			"health": 255,
			"strength": 50,
			"magic_power": 60,
			"defence": 30,
			"skills": ["death_dance", "mace", "heal"],
			"effect": "",
			"weapon": "",
			"armor": ""
		}
	}
