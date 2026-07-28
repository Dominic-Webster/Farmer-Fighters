extends Control

const ITEM_CARD_SCENE : PackedScene = preload("res://scenes/Almanac/ItemUI.tscn")
const ALMANAC_DATA : Script = preload("res://scenes/Almanac/almanac_data.gd")

@onready var back_button : Button = $BackButton

@onready var items : GridContainer = $ScrollContainer/GridContainer

@onready var item_info : Panel = $ItemInfo
@onready var item_name : Label = $ItemInfo/Name
@onready var item_desc : Label = $ItemInfo/Desc


func _ready() -> void:
	back_button.grab_focus()
	item_info.visible = false
	item_name.text = ""
	item_desc.text = ""
	_populate_items()
	
	back_button.mouse_entered.connect(_on_back_hovered)
	back_button.pressed.connect(_on_back_pressed)


func _populate_items() -> void:
	for child in items.get_children():
		child.queue_free()

	for entry in AlmanacData.ITEM_ENTRIES:
		_add_item_card(entry)


func _add_item_card(entry: Dictionary) -> void:
	var item_card := ITEM_CARD_SCENE.instantiate() as ItemUI
	if item_card == null:
		return

	items.add_child(item_card)
	item_card.setup(
		str(entry.get("id", "")),
		str(entry.get("name", "")),
		str(entry.get("desc", "")),
		entry.get("texture") as Texture2D,
		_is_item_found(str(entry.get("id", "")))
	)
	item_card.item_hovered.connect(_on_item_hovered)
	item_card.item_unhovered.connect(_on_item_unhovered)


func _is_item_found(item_id: String) -> bool:
	if MetaManager == null or item_id == "":
		return false

	var pickup_counts: Dictionary = MetaManager.meta_data.get("pickup_counts", {})
	return int(pickup_counts.get(item_id, 0)) > 0


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or event.is_action_pressed("back"):
		get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_back_hovered() -> void:
	back_button.grab_focus()


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu/main_menu.tscn")


func _on_item_hovered(item_ui: ItemUI) -> void:
	if item_ui == null:
		return

	item_name.text = item_ui.get_item_name()
	item_desc.text = item_ui.get_item_desc()
	item_info.visible = true


func _on_item_unhovered(_item_ui: ItemUI) -> void:
	item_info.visible = false
