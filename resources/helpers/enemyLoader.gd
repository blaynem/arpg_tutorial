extends Node

class_name EnemyLoader

const ENEMY_DATA_PATH = "res://resources/data/enemies.json"

static var instance = null

var enemy_data = null

func _ready():
	instance = self

static func get_instance():
	if not instance:
		instance = EnemyLoader.new()
	return instance

func get_enemy_data():
	if not enemy_data:
		var json = JSON.new()
		var json_as_text = FileAccess.get_file_as_string(ENEMY_DATA_PATH)
		var json_as_dict = JSON.parse_string(json_as_text)
		if json_as_dict:
			enemy_data = json_as_dict
		else:
			print("There was an error parsing the Enemy Data")

	return enemy_data

func get_data_by_name(enemy_name: String) -> Dictionary:
	var loader = get_instance()
	var data = loader.get_enemy_data()
	return data.get(enemy_name, null)
