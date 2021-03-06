extends Control

enum GameState {MOVE, USE_ITEM, COMBAT}

var game_state = GameState.MOVE

onready var game_data = $GameData
onready var drawer = $Drawer

onready var move_state = $MoveState
onready var use_item_state = $UseItemState
onready var combat_state = $CombatState

onready var map_label = $MapLabel
onready var player_stats_label = $PlayerStats
onready var inventory_items_label = $InventoryItems

onready var text_output_label = $TextOutput

onready var help = $Help

onready var map = game_data.map
onready var inventory = game_data.inventory
onready var characters = game_data.characters
onready var skills = game_data.skills
onready var items = game_data.items

onready var player = characters["player"]


func _ready():
	move_state.init()
	drawer.draw()


func _process(delta):
	if Input.is_action_just_pressed("help"):
		help.visible = not help.visible
	
	if not help.visible:
		if game_state == GameState.MOVE:
			move_state.process_state()
		elif game_state == GameState.USE_ITEM:
			use_item_state.process_state()
		elif game_state == GameState.COMBAT:
			combat_state.process_state()
		if player["health"] < 0: player["health"] = 0
		drawer.draw()


func show_message(text: String) -> void:
	text_output_label.text = text


func check_game_over():
	if player["health"] <= 0:
		player["health"] = 0
		show_message("No health, you die... Press SPACE to continue...")
		if Input.is_action_just_pressed("continue"):
			get_tree().change_scene("res://src/Interface/GameOver.tscn")
		

#State changing

func set_move_state():
	game_state = GameState.MOVE

func set_use_item_state(item_name: String, target_x: int, target_y: int, message: String) -> void:
	game_state = GameState.USE_ITEM
	use_item_state.set_state(item_name, target_x, target_y)
	show_message(message + "\n\nY/N")

func set_combat_state(enemy_key: String, enemy_x: int, enemy_y: int) -> void:
	game_state = GameState.COMBAT
	combat_state.set_state(characters[enemy_key], enemy_x, enemy_y)
