extends Node2D

var player_spell_manager: SpellStateManager = SpellStateManager.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	player_spell_manager.process(delta)

func add_player_spell(spell_id: String) -> void:
	player_spell_manager.add_spell_id_to_list(spell_id)

func cast_spell(spell_id: String):
	return player_spell_manager.cast_spell(spell_id)
