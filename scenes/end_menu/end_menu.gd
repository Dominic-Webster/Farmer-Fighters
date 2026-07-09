extends Control
class_name EndMenu

@onready var new_game_button : Button = $Buttons/New_Game
@onready var exit_button : Button = $Buttons/Exit
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var label : Label = $Label


func _ready() -> void:
	visible = false
	exit_button.pressed.connect(_on_exit_pressed)
	new_game_button.pressed.connect(_on_new_game_pressed)
	exit_button.mouse_entered.connect(_on_exit_hovered)
	new_game_button.mouse_entered.connect(_on_new_game_hovered)


func show_menu(_title : String) -> void:
	if _title != "":
		label.text = _title
	visible = true
	anim.play("blur")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	new_game_button.call_deferred("grab_focus")


func hide_menu() -> void:
	anim.play_backwards("blur")
	await anim.animation_finished
	visible = false


func _on_new_game_pressed():
	hide_menu()
	get_tree().paused = false
	
	RunManager.player.reset_player()
	
	RunManager.start_new_run(RunManager.player)


func _on_exit_pressed():
	get_tree().quit()
	#get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_new_game_hovered() -> void:
	new_game_button.grab_focus()


func _on_exit_hovered() -> void:
	exit_button.grab_focus()
