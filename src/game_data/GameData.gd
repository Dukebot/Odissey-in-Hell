class_name GameData extends Node


#onready var map = $Map.get_data()
#onready var characters = $Characters.get_data()
#onready var inventory = $Inventory.get_data()
#onready var items = $Items.get_data()
#onready var skills = $Skills.get_data()

onready var map = Utils.get_json_result("res://json/map.json")
onready var characters = Utils.get_json_result("res://json/characters.json")
onready var inventory = Utils.get_json_result("res://json/inventory.json")
onready var items = Utils.get_json_result("res://json/items.json")
onready var skills = Utils.get_json_result("res://json/skills.json")
