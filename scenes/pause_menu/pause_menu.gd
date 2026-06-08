extends Control
class_name PauseMenu

@onready var resume_button : Button = $Buttons/Resume
@onready var exit_button : Button = $Buttons/Exit


func _ready() -> void:
	visible = false
	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
	resume_button.grab_focus()


func _on_resume_pressed():
	visible = false
	get_tree().paused = false


func _on_exit_pressed():
	get_tree().quit()
	#get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
