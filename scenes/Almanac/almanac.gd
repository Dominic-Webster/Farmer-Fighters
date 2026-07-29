extends Control

const ITEM_CARD_SCENE : PackedScene = preload("res://scenes/Almanac/ItemUI.tscn")
const ALMANAC_DATA : Script = preload("res://scenes/Almanac/almanac_data.gd")

@onready var back_button : Button = $BackButton

@onready var collection_number : Label = $Collection

@onready var scroll_container : ScrollContainer = $ScrollContainer

@onready var items : GridContainer = $ScrollContainer/GridContainer

@onready var item_info : Panel = $ItemInfo
@onready var item_name : Label = $ItemInfo/Name
@onready var item_desc : Label = $ItemInfo/Desc

var _active_item : ItemUI = null


func _ready() -> void:
	scroll_container.follow_focus = true
	back_button.grab_focus()
	item_info.visible = false
	item_name.text = ""
	item_desc.text = ""
	_populate_items()
	collection_number.text = "Items Found: " + str(_get_found_count()) + "/" + str(AlmanacData.ITEM_ENTRIES.size())
	
	back_button.mouse_entered.connect(_on_back_hovered)
	back_button.pressed.connect(_on_back_pressed)
	call_deferred("_focus_first_item")


func _populate_items() -> void:
	for child in items.get_children():
		child.queue_free()
	_active_item = null
	item_info.visible = false

	for entry in AlmanacData.ITEM_ENTRIES:
		_add_item_card(entry)


func _get_found_count() -> int:
	var result : int = 0
	for child in items.get_children():
		var item_ui := child as ItemUI
		if item_ui != null and item_ui.is_item_found():
			result += 1
	return result


func _focus_first_item() -> void:
	if items.get_child_count() == 0:
		return

	var first_item := items.get_child(0) as ItemUI
	if first_item != null:
		first_item.grab_focus()
		_ensure_item_visible(first_item)


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
	item_card.navigation_requested.connect(_on_item_navigation_requested)


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

	_active_item = item_ui
	item_name.text = item_ui.get_item_name()
	item_desc.text = item_ui.get_item_desc()
	item_info.visible = true
	_ensure_item_visible(item_ui)


func _on_item_unhovered(_item_ui: ItemUI) -> void:
	if _item_ui != _active_item:
		return

	call_deferred("_hide_item_info_if_still_inactive", _item_ui)


func _hide_item_info_if_still_inactive(item_ui: ItemUI) -> void:
	if item_ui != _active_item:
		return

	if item_ui != null and item_ui.is_item_active():
		return

	_active_item = null
	item_info.visible = false
	item_name.text = ""
	item_desc.text = ""


func _ensure_item_visible(item_ui: ItemUI) -> void:
	if scroll_container == null or item_ui == null:
		return

	scroll_container.call_deferred("ensure_control_visible", item_ui)


func _on_item_navigation_requested(direction: String) -> void:
	var current_item := get_viewport().gui_get_focus_owner() as ItemUI
	if current_item == null:
		return

	var item_children: Array[ItemUI] = []
	for child in items.get_children():
		if child is ItemUI:
			item_children.append(child)

	var current_index := item_children.find(current_item)
	if current_index == -1:
		return

	var columns : int = max(1, items.columns)
	var target_index := current_index

	match direction:
		"up":
			target_index -= columns
		"down":
			target_index += columns
		"left":
			target_index -= 1
		"right":
			target_index += 1
		_:
			return

	if target_index < 0 or target_index >= item_children.size():
		return

	var target_item := item_children[target_index]
	if target_item != null:
		target_item.grab_focus()
		_ensure_item_visible(target_item)
