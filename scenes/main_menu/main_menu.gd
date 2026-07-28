# Main Menu
extends Control

var run_save : RunSave = RunSave.new()

@onready var play_button : Button = $Buttons/New_Game
@onready var continue_button : Button = $Buttons/Continue
@onready var options_button : Button = $Buttons/Options
@onready var back_button : Button = $Buttons/Back
@onready var almanac_button : Button = $Almanac


func _ready() -> void:
	continue_button.visible = run_save.has_save()
	
	play_button.pressed.connect(_on_play_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	options_button.pressed.connect(_on_options_pressed)
	back_button.pressed.connect(_on_back_pressed)
	almanac_button.pressed.connect(_on_almanac_pressed)
	
	play_button.mouse_entered.connect(_on_play_hovered)
	continue_button.mouse_entered.connect(_on_continue_hovered)
	options_button.mouse_entered.connect(_on_options_hovered)
	back_button.mouse_entered.connect(_on_back_hovered)
	almanac_button.mouse_entered.connect(_on_almanac_hovered)
	
	play_button.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().change_scene_to_file("res://scenes/PLAY/play_menu.tscn")


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Character_Select/Character_Select.tscn")


func _on_play_hovered() -> void:
	play_button.grab_focus()


func _on_continue_pressed() -> void:
	var run_data := run_save.load_run()
	if run_data.is_empty():
		return

	RunManager.start_loaded_run(run_data)
	get_tree().change_scene_to_file("res://scenes/00_Main_Game/MainGame.tscn")


func _on_continue_hovered() -> void:
	continue_button.grab_focus()


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/Options_Menu/options_menu.tscn")


func _on_options_hovered() -> void:
	options_button.grab_focus()


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/PLAY/play_menu.tscn")


func _on_back_hovered() -> void:
	back_button.grab_focus()


func _on_almanac_pressed():
	get_tree().change_scene_to_file("res://scenes/Almanac/Almanac.tscn")


func _on_almanac_hovered() -> void:
	almanac_button.grab_focus()
