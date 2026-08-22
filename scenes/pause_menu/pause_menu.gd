extends Control
class_name PauseMenu

var run_save : RunSave = RunSave.new()

@onready var resume_button : Button = $Buttons/Resume
@onready var new_game_button : Button = $Buttons/New_Game
@onready var exit_button : Button = $Buttons/Exit
@onready var audio_button : Button = $Buttons/Audio
@onready var visuals_button : Button = $Buttons/Visuals
@onready var menu_button : Button = $Buttons/Main_Menu
@onready var anim : AnimationPlayer = $AnimationPlayer

@onready var audio_panel : Control = $AudioPanel
@onready var audio_back : Button = $AudioPanel/Back
@onready var audio_master_slider : HSlider = $AudioPanel/MasterSlider


func _ready() -> void:
	visible = false
	audio_panel.visible = false
	
	audio_master_slider.value = SettingsManager.get_master_volume()
	audio_master_slider.value_changed.connect(_on_master_volume_changed)
	
	resume_button.pressed.connect(_on_resume_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	menu_button.pressed.connect(_on_menu_pressed)
	new_game_button.pressed.connect(_on_new_game_pressed)
	audio_button.pressed.connect(_on_audio_pressed)
	audio_back.pressed.connect(_on_audio_back_pressed)
	
	resume_button.mouse_entered.connect(_on_resume_hovered)
	exit_button.mouse_entered.connect(_on_exit_hovered)
	audio_button.mouse_entered.connect(_on_audio_hovered)
	visuals_button.mouse_entered.connect(_on_visuals_hovered)
	menu_button.mouse_entered.connect(_on_menu_hovered)
	new_game_button.mouse_entered.connect(_on_new_game_hovered)
	audio_back.mouse_entered.connect(_on_audio_back_hovered)


func _re_enable() -> void:
	audio_button.disabled = false
	audio_button.focus_mode = Control.FOCUS_ALL
	visuals_button.disabled = false
	visuals_button.focus_mode = Control.FOCUS_ALL
	resume_button.disabled = false
	resume_button.focus_mode = Control.FOCUS_ALL
	exit_button.disabled = false
	exit_button.focus_mode = Control.FOCUS_ALL
	new_game_button.disabled = false
	new_game_button.focus_mode = Control.FOCUS_ALL
	menu_button.disabled = false
	menu_button.focus_mode = Control.FOCUS_ALL


func _disable() -> void:
	audio_button.disabled = true
	audio_button.focus_mode = Control.FOCUS_NONE
	visuals_button.disabled = true
	visuals_button.focus_mode = Control.FOCUS_NONE
	resume_button.disabled = true
	resume_button.focus_mode = Control.FOCUS_NONE
	exit_button.disabled = true
	exit_button.focus_mode = Control.FOCUS_NONE
	new_game_button.disabled = true
	new_game_button.focus_mode = Control.FOCUS_NONE
	menu_button.disabled = true
	menu_button.focus_mode = Control.FOCUS_NONE


func show_menu() -> void:
	visible = true
	anim.play("blur")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	resume_button.call_deferred("grab_focus")


func hide_menu() -> void:
	anim.play_backwards("blur")
	await anim.animation_finished
	visible = false


func _on_resume_pressed():
	hide_menu()
	get_tree().paused = false


func _on_new_game_pressed():
	hide_menu()
	get_tree().paused = false
	run_save.clear_save()
	
	RunManager.player.reset_player()
	
	RunManager.start_new_run(RunManager.player)


func _on_audio_pressed() -> void:
	_disable()
	audio_panel.visible = true
	audio_back.grab_focus()


func _on_audio_back_hovered() -> void:
	audio_back.grab_focus()


func _on_audio_back_pressed() -> void:
	audio_panel.visible = false
	_re_enable()
	audio_button.grab_focus()


func _on_master_volume_changed(value: float) -> void:
	SettingsManager.set_master_volume(value)


func _on_exit_pressed():
	run_save.save_run()
	get_tree().quit()
	#get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_menu_pressed():
	run_save.save_run()
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_resume_hovered() -> void:
	resume_button.grab_focus()


func _on_menu_hovered() -> void:
	menu_button.grab_focus()


func _on_new_game_hovered() -> void:
	new_game_button.grab_focus()


func _on_audio_hovered() -> void:
	audio_button.grab_focus()


func _on_visuals_hovered() -> void:
	visuals_button.grab_focus()


func _on_exit_hovered() -> void:
	exit_button.grab_focus()
