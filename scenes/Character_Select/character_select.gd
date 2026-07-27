extends Control

@onready var icon : TextureRect = $CenterContainer/VBoxContainer/CharacterSpriteHolder/CharacterSprite
@onready var char_name : Label = $CenterContainer/VBoxContainer/CharacterName
@onready var char_desc : Label = $CenterContainer/VBoxContainer/CharacterDescription
@onready var lock_icon : TextureRect = $CenterContainer/VBoxContainer/CharacterSpriteHolder/LockIcon

@onready var left_button : TextureButton = $LeftButton
@onready var right_button : TextureButton = $RightButton
@onready var back_button : Button = $BackButton
@onready var select_button : Button = $SelectButton

@export var characters : Array[CharacterInfo]
var selected_index : int = 0


func _ready() -> void:
	if characters.size() == 0:
		return

	_sync_character_unlocks()
	if MetaManager != null and not MetaManager.meta_changed.is_connected(_on_meta_changed):
		MetaManager.meta_changed.connect(_on_meta_changed)
	
	select_button.grab_focus()
	
	select_button.mouse_entered.connect(_on_select_hovered)
	back_button.mouse_entered.connect(_on_back_hovered)
	right_button.mouse_entered.connect(_on_right_hovered)
	left_button.mouse_entered.connect(_on_left_hovered)
	
	select_button.pressed.connect(_on_select_pressed)
	back_button.pressed.connect(_on_back_pressed)
	right_button.pressed.connect(_on_right_pressed)
	left_button.pressed.connect(_on_left_pressed)
	
	set_current_character()


func _sync_character_unlocks() -> void:
	if MetaManager == null:
		return

	for character in characters:
		if character == null or character.unlock_id == "":
			continue
		character.unlocked = MetaManager.is_character_unlocked(character.unlock_id)


func _on_meta_changed() -> void:
	_sync_character_unlocks()
	set_current_character()


func set_current_character() -> void:
	icon.texture = characters[selected_index].icon
	char_name.text = characters[selected_index].player_data.name
	
	if characters[selected_index].unlocked == false:
		icon.modulate = Color(0.332, 0.332, 0.332, 1.0)
		char_desc.text = characters[selected_index].unlock_text
		lock_icon.visible = true
	else:
		icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
		char_desc.text = characters[selected_index].description
		lock_icon.visible = false
	
	set_select_button()


func set_select_button() -> void:
	select_button.visible = characters[selected_index].unlocked


func _on_right_pressed() -> void:
	selected_index += 1
	if selected_index == characters.size():
		selected_index = 0
	
	set_current_character()

func _on_right_hovered() -> void:
	right_button.grab_focus()


func _on_left_pressed() -> void:
	selected_index -= 1
	if selected_index < 0:
		selected_index = characters.size() - 1
	
	set_current_character()

func _on_left_hovered() -> void:
	left_button.grab_focus()


func _on_select_pressed() -> void:
	RunSave.new().clear_save()
	RunManager.player_data = characters[selected_index].player_data
	get_tree().change_scene_to_file("res://scenes/00_Main_Game/MainGame.tscn")

func _on_select_hovered() -> void:
	select_button.grab_focus()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")

func _on_back_hovered() -> void:
	back_button.grab_focus()
