extends Control

@onready var audio_button : Button = $Buttons/Audio
@onready var reset_save_button : Button = $Buttons/Reset_Save
@onready var back_button : Button = $Buttons/Back

@onready var reset_save_panel : Control = $Reset_Save_Option
@onready var reset_option_text : Label = $Reset_Save_Option/VBoxContainer/Label
@onready var yes_reset_button : Button = $Reset_Save_Option/VBoxContainer/HBoxContainer/Yes
@onready var no_reset_button : Button = $Reset_Save_Option/VBoxContainer/HBoxContainer/No


func _ready() -> void:
	reset_save_panel.visible = false
	back_button.grab_focus()
	
	reset_save_button.mouse_entered.connect(_on_reset_hovered)
	reset_save_button.pressed.connect(_on_reset_pressed)
	no_reset_button.mouse_entered.connect(_on_no_reset_hovered)
	no_reset_button.pressed.connect(_on_no_reset_pressed)
	yes_reset_button.mouse_entered.connect(_on_yes_reset_hovered)
	yes_reset_button.pressed.connect(_on_yes_reset_pressed)
	back_button.mouse_entered.connect(_on_back_hovered)
	back_button.pressed.connect(_on_back_pressed)


func _on_reset_hovered() -> void:
	reset_save_button.grab_focus()


func _on_reset_pressed() -> void:
	reset_save_panel.visible = true
	reset_option_text.text = "Are you sure you want to reset your save?"
	no_reset_button.visible = true
	yes_reset_button.visible = true
	no_reset_button.grab_focus()


func _on_yes_reset_hovered() -> void:
	yes_reset_button.grab_focus()


func _on_yes_reset_pressed() -> void:
	if MetaManager != null:
		MetaManager.reset_progress_to_base()
	
	no_reset_button.visible = false
	yes_reset_button.visible = false
	reset_option_text.text = "SAVE RESET!"
	
	await get_tree().create_timer(1.0).timeout
	
	reset_save_panel.visible = false
	reset_save_button.grab_focus()


func _on_no_reset_hovered() -> void:
	no_reset_button.grab_focus()


func _on_no_reset_pressed() -> void:
	reset_save_panel.visible = false
	reset_save_button.grab_focus()


func _on_back_hovered() -> void:
	back_button.grab_focus()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
