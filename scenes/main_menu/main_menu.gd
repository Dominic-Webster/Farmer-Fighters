# Main Menu
extends Control

@onready var play_button : Button = $Buttons/Play
@onready var exit_button : Button = $Buttons/Exit


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	play_button.mouse_entered.connect(_on_play_hovered)
	exit_button.mouse_entered.connect(_on_exit_hovered)
	
	play_button.grab_focus()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/00_Main_Game/MainGame.tscn")

func _on_play_hovered() -> void:
	play_button.grab_focus()


func _on_exit_pressed():
	get_tree().quit()

func _on_exit_hovered() -> void:
	exit_button.grab_focus()
