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



func update_hp( _hp : int, _max_hp : int ) -> void:
	update_max_hp( _max_hp )
	for i in _max_hp:
		update_heart( i, _hp )
	
	pass



func update_heart( _index : int, _hp : int ) -> void:
	var _value : int = clampi( _hp - _index * 2, 0, 2 )
	hearts[ _index ].value = _value
	pass



func update_max_hp( _max_hp : int ) -> void:
	var _heart_count : int = roundi( _max_hp * 0.5 )
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass


func show_item_info(iname : String, desc : String) -> void:
	item_info_name.text = iname
	item_info_desc.text = desc
	item_info.visible = true
	item_info_timer.start()



func hide_item_info() -> void:
	item_info.visible = false
