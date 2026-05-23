extends CanvasLayer
class_name PlayerHud

@onready var health : HFlowContainer = $Control/Health
@onready var item_info : Panel = $Control/ItemInfo
@onready var item_info_name : Label = $Control/ItemInfo/ItemName
@onready var item_info_desc : Label = $Control/ItemInfo/ItemDesc
@onready var item_info_timer : Timer = $ItemInfoTimer

@export var heart_scene : PackedScene
var hearts : Array[HeartGUI] = []
@export var max_hearts : int = 50 # Default, can be set in editor


func _ready():
	item_info.visible = false
	item_info_timer.wait_time = 2.0
	item_info_timer.one_shot = true
	item_info_timer.timeout.connect(hide_item_info)
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


func show_item_info(iname : String, desc : String) -> void:
	item_info_name.text = iname
	item_info_desc.text = desc
	item_info.visible = true
	item_info_timer.start()


func hide_item_info() -> void:
	item_info.visible = false
