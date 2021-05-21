extends Control

const MAIN_SCENE_PATH = "res://src/Main.tscn"

var dialogue_index : int = 0

onready var intro_data = Utils.get_json_result("res://json/intro.json")
onready var intro_story = intro_data["intro_story"]
onready var intro_dialogue = intro_data["intro_dialogue"]

onready var intro_text_label = find_node("IntroText")
onready var dialogue_label = find_node("DialogueLabel")
onready var player_name_input = find_node("PlayerNameInput")


func _ready():
	intro_text_label.set_text(intro_story)


func _process(delta):
	#Intro Text
	if intro_text_label.text != "":
		if Input.is_action_just_pressed("continue"):
			intro_text_label.text = ""
		return
	
	#Dialogue Text
	if dialogue_index < intro_dialogue.size():
		var dialogue_line = intro_dialogue[dialogue_index]
		var speaker = dialogue_line[0]
		var text = dialogue_line[1]
		
		#Initialization of Player_Name
		if speaker == "":
			player_name_input.set_visible(true)
			if Input.is_action_just_pressed("continue"):
				if player_name_input.text != null and player_name_input.text != "":
					Globals.player_name = player_name_input.text.strip_edges(true, true)
					player_name_input.set_visible(false)
					dialogue_index += 1
		#Normal dialogue Flow
		else:
			if speaker == "player_name": speaker = Globals.player_name
			text = text.replace("player_name", Globals.player_name)
			
			dialogue_label.set_text(speaker + " - " + text)
			if Input.is_action_just_pressed("continue"):
				dialogue_index += 1
	#Start Advernture text
	else:
		dialogue_label.set_text("Press SPACE to start adventure!")
		if Input.is_action_just_pressed("continue"):
			get_tree().change_scene(MAIN_SCENE_PATH)
