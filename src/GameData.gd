class_name GameData extends Node

onready var map = Utils.get_json_result("res://json/map.json")
onready var characters = Utils.get_json_result("res://json/characters.json")
onready var inventory = Utils.get_json_result("res://json/inventory.json")
onready var items = Utils.get_json_result("res://json/items.json")
onready var skills = Utils.get_json_result("res://json/skills.json")


func _ready():
	for key in characters.keys():
		var character = characters[key]
		character["max_health"] = character["health"]
