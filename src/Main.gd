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

onready var map = game_data.map
onready var inventory = game_data.inventory
onready var characters = game_data.characters
onready var skills = game_data.skills

onready var player = characters["player"]


func _ready():
	move_state.init(map)
	drawer.draw()


func _process(delta):
	if game_state == GameState.MOVE:
		move_state.process_state()
	elif game_state == GameState.USE_ITEM:
		use_item_state.process_state()
	elif game_state == GameState.COMBAT:
		combat_state.process_state()
	drawer.draw()


func set_move_state():
	game_state = GameState.MOVE


func set_use_item_state(item_name: String, target_x: int, target_y: int) -> void:
	game_state = GameState.USE_ITEM
	use_item_state.use_item = item_name
	use_item_state.use_item_x = target_x
	use_item_state.use_item_y = target_y


func set_combat_state(enemy_key: String, enemy_x: int, enemy_y: int) -> void:
	game_state = GameState.COMBAT
	combat_state.turn = 0
	combat_state.enemy = characters[enemy_key].duplicate()
	combat_state.enemy_x = enemy_x
	combat_state.enemy_y = enemy_y


func show_message(text: String) -> void:
	text_output_label.text = text
