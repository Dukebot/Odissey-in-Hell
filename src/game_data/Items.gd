extends Node


func get_data():
	return {
		"copper_sword": {
			"name": "Copper Sword",
			"effect": [
				["strength", 10]
			],
			"interaction": ""
		},
		"masamune": {
			"name": "Masamune",
			"effect": [
				["strength", 30]
			],
			"interaction": "There's a KATANA on a pedestal. You throw your SWORD and take the KATANA, your attack increases considerably."
		},
		"leather_armor": {
			"name": "Leather Armor",
			"effect": [
				["deffence", 5]
			],
			"interaction": ""
		},
		"onyx_armor": {
			"name": "Onyx Armor",
			"effect": [
				["deffence", 15]
			],
			"interaction": "There's an ARMOUR on the floor. You throw your ARMOUR and take the other one, your defence increases considerably."
		}
	}
