extends Control
class_name EndMenu

var run_save : RunSave = RunSave.new()

@onready var new_game_button : Button = $Buttons/New_Game
@onready var exit_button : Button = $Buttons/Exit
@onready var menu_button : Button = $Buttons/Main_Menu
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var label : Label = $Label
@onready var seed_label : Label = $SeedLabel


func _ready() -> void:
	visible = false
	exit_button.pressed.connect(_on_exit_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	new_game_button.pressed.connect(_on_new_game_pressed)
	exit_button.mouse_entered.connect(_on_exit_hovered)
	menu_button.mouse_entered.connect(_on_menu_hovered)
	new_game_button.mouse_entered.connect(_on_new_game_hovered)


func show_menu(_title : String) -> void:
	if _title != "":
		label.text = _title
	seed_label.text = "Seed: " + str(RunManager.run_seed)
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
	run_save.clear_save()
	
	RunManager.player.reset_player()
	
	RunManager.start_new_run(RunManager.player)


func _on_menu_pressed():
	run_save.clear_save()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_exit_pressed():
	run_save.clear_save()
	get_tree().quit()


func _on_new_game_hovered() -> void:
	new_game_button.grab_focus()


func _on_menu_hovered() -> void:
	menu_button.grab_focus()


func _on_exit_hovered() -> void:
	exit_button.grab_focus()
