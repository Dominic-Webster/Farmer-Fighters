extends CanvasLayer
class_name PlayerHud


@onready var health : HFlowContainer = $Control/Health
@export var heart_scene : PackedScene
var hearts : Array[HeartGUI] = []
@export var max_hearts : int = 50 # Default, can be set in editor



func _ready():
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
