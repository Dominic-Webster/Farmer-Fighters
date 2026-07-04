extends Control
class_name PauseMenu

@onready var resume_button : Button = $Buttons/Resume
@onready var exit_button : Button = $Buttons/Exit
@onready var anim : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	visible = false
	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	resume_button.mouse_entered.connect(_on_resume_hovered)
	exit_button.mouse_entered.connect(_on_exit_hovered)


func show_menu() -> void:
	visible = true
	anim.play("blur")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	resume_button.call_deferred("grab_focus")


func hide_menu() -> void:
	visible = false


func _on_resume_pressed():
	hide_menu()
	get_tree().paused = false


func _on_exit_pressed():
	get_tree().quit()
	#get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_resume_hovered() -> void:
	resume_button.grab_focus()


func _on_exit_hovered() -> void:
	exit_button.grab_focus()
