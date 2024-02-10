extends Node

class_name SpellLoader

const SPELL_DATA_PATH = "res://resources/data/spells.json"

static var instance = null

var spells_data = null

func _ready():
	instance = self

static func get_instance():
	if not instance:
		instance = SpellLoader.new()
	return instance

func get_spell_data():
	if not spells_data:
		var json_as_text = FileAccess.get_file_as_string(SPELL_DATA_PATH)
		var json_as_dict = JSON.parse_string(json_as_text)
		if json_as_dict:
			spells_data = json_as_dict
		else:
			print("There was an error parsing the Enemy Data")

	return spells_data

# Returns a dictionary with the spell data
func get_spell_by_id(spell_id: String) -> Dictionary:
	var loader = SpellLoader.get_instance()
	var data = loader.get_spell_data()
	return data.get(spell_id, null)
