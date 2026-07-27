extends CanvasLayer
class_name PlayerHud

@onready var health : HFlowContainer = $Control/Health
@onready var item_choice : Panel = $Control/ItemChoice
@onready var item_choice_name : Label = $Control/ItemChoice/Name
@onready var item_choice_desc : Label = $Control/ItemChoice/Desc
@onready var item_choice_take_button : Button = $Control/ItemChoice/HBoxContainer/Take
@onready var item_choice_abandon_button : Button = $Control/ItemChoice/HBoxContainer/Abandon
@onready var unlock_info : Panel = $Control/UnlockInfo
@onready var unlock_info_name : Label = $Control/UnlockInfo/Name
@onready var unlock_info_desc : Label = $Control/UnlockInfo/Desc
@onready var unlock_info_timer : Timer = $UnlockInfoTimer

@export var heart_scene : PackedScene
var hearts : Array[HeartGUI] = []
@export var max_hearts : int = 50 # Default, can be set in editor
var current_item : Item = null


func _ready():
	unlock_info.visible = false
	item_choice.visible = false
	unlock_info_timer.wait_time = 3.0
	unlock_info_timer.one_shot = true
	unlock_info_timer.timeout.connect(hide_unlock_info)
	item_choice_take_button.focus_mode = Control.FOCUS_ALL
	item_choice_abandon_button.focus_mode = Control.FOCUS_ALL
	item_choice_take_button.focus_neighbor_right = item_choice_abandon_button.get_path()
	item_choice_abandon_button.focus_neighbor_left = item_choice_take_button.get_path()
	if not item_choice_take_button.pressed.is_connected(_on_item_choice_take_pressed):
		item_choice_take_button.pressed.connect(_on_item_choice_take_pressed)
	if not item_choice_abandon_button.pressed.is_connected(_on_item_choice_abandon_pressed):
		item_choice_abandon_button.pressed.connect(_on_item_choice_abandon_pressed)
	# Remove any existing children
	for child in health.get_children():
		child.queue_free()
	hearts.clear()
	# Instance heart nodes
	for i in range(max_hearts):
		var heart = heart_scene.instantiate()
		health.add_child(heart)
		hearts.append(heart)
		heart.visible = false
	pass



func update_hp(_hp: int, _max_hp: int, _heart_type: Variant = null, _num_hearts: int = 0) -> void:
	# Always hide all hearts first
	for h in hearts:
		h.visible = false
	var heart_value = 2
	var max_frame = 2
	if _heart_type != null:
		match _heart_type:
			0:
				heart_value = 2 # TOMATO
				max_frame = 2
			1:
				heart_value = 3 # CARROT
				max_frame = 3
	@warning_ignore("integer_division")
	var heart_count = _num_hearts if _num_hearts > 0 else int(_max_hp / heart_value)
	heart_count = mini(heart_count, hearts.size())
	for i in range(heart_count):
		update_heart(i, _hp, heart_value, _heart_type, max_frame)
		hearts[i].visible = true



func update_heart(_index: int, _hp: int, heart_value := 2, _heart_type: Variant = null, _max_frame := 2) -> void:
	var raw_value = _hp - _index * heart_value
	var _value = clampi(raw_value, 0, heart_value)
	# Map value to frame count
	var frame = 0
	if heart_value == 2:
		# Tomato: 0=empty, 1=half, 2=full
		frame = _value
	elif heart_value == 3:
		# Carrot: 0=empty, 1=1/3, 2=2/3, 3=full
		frame = _value
	if "set_heart" in hearts[_index]:
		hearts[_index].set_heart(frame, _heart_type)
	else:
		hearts[_index].value = frame


func update_max_hp(_max_hp: int, _heart_type: Variant = null) -> void:
	pass


func show_item_info(iname : String, desc : String, item : Item = null) -> void:
	current_item = item
	if item != null:
		iname = item.get_item_name()
		desc = item.get_item_desc()
	item_choice_name.text = iname
	item_choice_desc.text = desc
	item_choice.visible = true
	if RunManager.player != null and "set_movement_locked" in RunManager.player:
		RunManager.player.set_movement_locked(true)
	item_choice_take_button.call_deferred("grab_focus")


func hide_item_info() -> void:
	current_item = null
	item_choice.visible = false
	if RunManager.player != null and "set_movement_locked" in RunManager.player:
		RunManager.player.set_movement_locked(false)


func _on_item_choice_take_pressed() -> void:
	var item := current_item
	if is_instance_valid(item):
		item.desc = item.get_item_desc()
	hide_item_info()
	if is_instance_valid(item):
		item.call("_on_body_entered", RunManager.player)


func _on_item_choice_abandon_pressed() -> void:
	var item := current_item
	hide_item_info()
	if is_instance_valid(item):
		item.abandon_item()


func show_unlock_info(iname : String, desc : String) -> void:
	unlock_info_name.text = iname
	unlock_info_desc.text = desc
	unlock_info.visible = true
	unlock_info_timer.start()


func hide_unlock_info() -> void:
	unlock_info.visible = false
