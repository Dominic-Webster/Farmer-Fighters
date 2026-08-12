extends Control

var run_save : RunSave = RunSave.new()

@onready var audio_button : Button = $Buttons/Audio
@onready var controls_button : Button = $Buttons/Controls
@onready var reset_save_button : Button = $Buttons/Reset_Save
@onready var back_button : Button = $Buttons/Back

@onready var reset_save_panel : Control = $Reset_Save_Option
@onready var reset_option_text : Label = $Reset_Save_Option/VBoxContainer/Label
@onready var yes_reset_button : Button = $Reset_Save_Option/VBoxContainer/HBoxContainer/Yes
@onready var no_reset_button : Button = $Reset_Save_Option/VBoxContainer/HBoxContainer/No

@onready var controls_panel : Control = $ControlsPanel
@onready var controls_back : Button = $ControlsPanel/Back
@onready var controls_keyboard_button : Button = $ControlsPanel/HBoxContainer/Keyboard
@onready var controls_controller_button : Button = $ControlsPanel/HBoxContainer/Controller
@onready var controls_keyboard_label : Label = $ControlsPanel/KeyboardLabel
@onready var controls_controller_label : Label = $ControlsPanel/ControllerLabel


func _ready() -> void:
	reset_save_panel.visible = false
	controls_panel.visible = false
	back_button.grab_focus()
	
	controls_button.mouse_entered.connect(_on_controls_hovered)
	controls_button.pressed.connect(_on_controls_pressed)
	controls_back.mouse_entered.connect(_on_controls_back_hovered)
	controls_back.pressed.connect(_on_controls_back_pressed)
	controls_keyboard_button.mouse_entered.connect(_on_controls_keyboard_hovered)
	controls_keyboard_button.pressed.connect(_on_controls_keyboard_pressed)
	controls_controller_button.mouse_entered.connect(_on_controls_controller_hovered)
	controls_controller_button.pressed.connect(_on_controls_controller_pressed)
	
	reset_save_button.mouse_entered.connect(_on_reset_hovered)
	reset_save_button.pressed.connect(_on_reset_pressed)
	no_reset_button.mouse_entered.connect(_on_no_reset_hovered)
	no_reset_button.pressed.connect(_on_no_reset_pressed)
	yes_reset_button.mouse_entered.connect(_on_yes_reset_hovered)
	yes_reset_button.pressed.connect(_on_yes_reset_pressed)
	
	back_button.mouse_entered.connect(_on_back_hovered)
	back_button.pressed.connect(_on_back_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("back"):
		if reset_save_panel.visible == false:
			get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
		else:
			reset_save_panel.visible = false
			controls_panel.visible = false
			_re_enable()


func _re_enable() -> void:
	audio_button.disabled = false
	audio_button.focus_mode = Control.FOCUS_ALL
	controls_button.disabled = false
	controls_button.focus_mode = Control.FOCUS_ALL
	reset_save_button.disabled = false
	reset_save_button.focus_mode = Control.FOCUS_ALL
	back_button.disabled = false
	back_button.focus_mode = Control.FOCUS_ALL


func _disable() -> void:
	audio_button.disabled = true
	audio_button.focus_mode = Control.FOCUS_NONE
	controls_button.disabled = true
	controls_button.focus_mode = Control.FOCUS_NONE
	reset_save_button.disabled = true
	reset_save_button.focus_mode = Control.FOCUS_NONE
	back_button.disabled = true
	back_button.focus_mode = Control.FOCUS_NONE

# -----------
# CONTROLS
# -----------

func _on_controls_hovered() -> void:
	controls_button.grab_focus()


func _on_controls_pressed() -> void:
	_disable()
	controls_panel.visible = true
	controls_keyboard_button.grab_focus()
	controls_keyboard_label.visible = true
	controls_controller_label.visible = false


func _on_controls_back_hovered() -> void:
	controls_back.grab_focus()


func _on_controls_back_pressed() -> void:
	controls_panel.visible = false
	_re_enable()
	controls_button.grab_focus()


func _on_controls_keyboard_hovered() -> void:
	controls_keyboard_button.grab_focus()


func _on_controls_keyboard_pressed() -> void:
	controls_keyboard_label.visible = true
	controls_controller_label.visible = false


func _on_controls_controller_hovered() -> void:
	controls_controller_button.grab_focus()


func _on_controls_controller_pressed() -> void:
	controls_controller_label.visible = true
	controls_keyboard_label.visible = false

# -----------
# RESET SAVE
# -----------

func _on_reset_hovered() -> void:
	reset_save_button.grab_focus()


func _on_reset_pressed() -> void:
	reset_save_panel.visible = true
	
	_disable()
	
	reset_option_text.text = "Are you sure you want to reset your save?"
	no_reset_button.visible = true
	yes_reset_button.visible = true
	no_reset_button.grab_focus()


func _on_yes_reset_hovered() -> void:
	yes_reset_button.grab_focus()


func _on_yes_reset_pressed() -> void:
	if MetaManager != null:
		MetaManager.reset_progress_to_base()
	run_save.clear_save()
	if RunManager != null:
		RunManager.pending_run_data.clear()
	
	no_reset_button.visible = false
	yes_reset_button.visible = false
	reset_option_text.text = "SAVE RESET!"
	
	await get_tree().create_timer(1.0).timeout
	
	_re_enable()
	
	reset_save_panel.visible = false
	reset_save_button.grab_focus()


func _on_no_reset_hovered() -> void:
	no_reset_button.grab_focus()


func _on_no_reset_pressed() -> void:
	reset_save_panel.visible = false
	_re_enable()
	reset_save_button.grab_focus()


func _on_back_hovered() -> void:
	back_button.grab_focus()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")
