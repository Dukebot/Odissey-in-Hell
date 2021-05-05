class_name GameData extends Node

onready var map = get_json_result("game_data/map.json")
onready var characters = get_json_result("game_data/characters.json")
onready var inventory = get_json_result("game_data/inventory.json")
onready var items = get_json_result("game_data/items.json")
onready var skills = get_json_result("game_data/skills.json")


func _ready():
	print(map)


static func get_json_result(json_path: String):
	var file = File.new()
	file.open(json_path, file.READ)
	var json_string = file.get_as_text()
	var json_result = JSON.parse(json_string).result
	file.close()
	return json_result
