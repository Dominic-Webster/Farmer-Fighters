extends Control
class_name CharacterSelect

@onready var dave_button : Button = $HBoxContainer/Dave
@onready var mac_button : Button = $HBoxContainer/Mac
@onready var jane_button : Button = $HBoxContainer/Jane
@onready var play_button : Button = $VBoxContainer/Play
@onready var back_button : Button = $Back

@export var dave_data : PlayerData
@export var mac_data : PlayerData
@export var jane_data : PlayerData

var selected_data : PlayerData

func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	back_button.pressed.connect(_on_back_pressed)
	dave_button.pressed.connect(_on_dave_pressed)
	mac_button.pressed.connect(_on_mac_pressed)
	jane_button.pressed.connect(_on_jane_pressed)
	
	dave_button.grab_focus()
	dave_button.modulate = Color(1.0, 1.0, 0.588, 1.0)
	selected_data = dave_data


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("back"):
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_play_pressed() -> void:
	RunSave.new().clear_save()
	RunManager.player_data = selected_data
	get_tree().change_scene_to_file("res://scenes/00_Main_Game/MainGame.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_dave_pressed() -> void:
	reset_button_vis()
	dave_button.grab_focus()
	dave_button.modulate = Color(1.0, 1.0, 0.588, 1.0)
	selected_data = dave_data


func _on_mac_pressed() -> void:
	reset_button_vis()
	mac_button.grab_focus()
	mac_button.modulate = Color(1.0, 1.0, 0.588, 1.0)
	selected_data = mac_data


func _on_jane_pressed() -> void:
	reset_button_vis()
	jane_button.grab_focus()
	jane_button.modulate = Color(1.0, 1.0, 0.588, 1.0)
	selected_data = jane_data


func reset_button_vis() -> void:
	dave_button.modulate = Color(1.0, 1.0, 1.0, 1.0)
	mac_button.modulate = Color(1.0, 1.0, 1.0, 1.0)
	jane_button.modulate = Color(1.0, 1.0, 1.0, 1.0)
