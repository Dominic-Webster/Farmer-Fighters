# Main Menu
extends Control

var run_save : RunSave = RunSave.new()

@onready var play_button : Button = $Buttons/New_Game
@onready var continue_button : Button = $Buttons/Continue
@onready var exit_button : Button = $Buttons/Exit


func _ready() -> void:
	continue_button.visible = run_save.has_save()
	play_button.pressed.connect(_on_play_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	play_button.mouse_entered.connect(_on_play_hovered)
	continue_button.mouse_entered.connect(_on_continue_hovered)
	exit_button.mouse_entered.connect(_on_exit_hovered)
	
	play_button.grab_focus()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().quit()


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


func _on_exit_pressed():
	get_tree().quit()


func _on_exit_hovered() -> void:
	exit_button.grab_focus()
