extends Node

const SETTINGS_PATH := "user://settings.cfg"
const DEFAULT_MASTER_VOLUME := 50.0

var master_volume: float = DEFAULT_MASTER_VOLUME


func _ready() -> void:
	_load_settings()
	_apply_master_volume()


func get_master_volume() -> float:
	return master_volume


func set_master_volume(value: float) -> void:
	master_volume = clampf(value, 0.0, 100.0)
	_apply_master_volume()
	_save_settings()


func _load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) == OK:
		master_volume = clampf(config.get_value("audio", "master_volume", DEFAULT_MASTER_VOLUME), 0.0, 100.0)


func _save_settings() -> void:
	var config := ConfigFile.new()
	config.load(SETTINGS_PATH)
	config.set_value("audio", "master_volume", master_volume)
	config.save(SETTINGS_PATH)


func _apply_master_volume() -> void:
	var master_bus_index := AudioServer.get_bus_index("Master")
	if master_bus_index == -1:
		return

	var volume_db := -80.0 if master_volume <= 0.0 else linear_to_db(master_volume / 100.0)
	AudioServer.set_bus_volume_db(master_bus_index, volume_db)
