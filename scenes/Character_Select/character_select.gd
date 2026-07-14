extends Control
class_name CharacterSelect

@onready var dave_button : Button = $HBoxContainer/Dave
@onready var mac_button : Button = $HBoxContainer/Mac
@onready var play_button : Button = $VBoxContainer/Play
@onready var back_button : Button = $Back

@export var dave_data : PlayerData
@export var mac_data : PlayerData

var selected_data : PlayerData

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	back_button.pressed.connect(_on_back_pressed)
	dave_button.pressed.connect(_on_dave_pressed)
	mac_button.pressed.connect(_on_mac_pressed)
	
	dave_button.grab_focus()
	selected_data = dave_data


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_play_pressed() -> void:
	RunManager.player_data = selected_data
	get_tree().change_scene_to_file("res://scenes/00_Main_Game/MainGame.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_dave_pressed() -> void:
	dave_button.grab_focus()
	selected_data = dave_data


func _on_mac_pressed() -> void:
	mac_button.grab_focus()
	selected_data = mac_data
