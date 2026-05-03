# Main Menu
extends Control

@onready var play_button : Button = $Play


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/test.tscn")
