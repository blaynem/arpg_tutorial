extends Node2D

# Define the state machine states
enum SpellState {
	READY,
	COOLDOWN,
	CASTING
}

var spell_loader = SpellLoader.get_instance()

# Define a custom data structure for spells
class SpellData:
	var id: String
	var cooldown: float
	var remaining_cooldown: float
	var state: SpellState = SpellState.READY

	func _init(spell_id: String, spell_cooldown: float):
		self.id = spell_id
		self.cooldown = spell_cooldown
		self.remaining_cooldown = 0

#  Example spell JSON
# {
#     "id": "fireball",
#     "name": "Fireball",
#     "description": "A single fireball",
#     "type": "Fire",
#     "maxDistance": 99999,
#     "cooldown": 1,
#     "castTime": 0,
#     "projectileSpeed": 100,
#     "damage": 10
# }

var castable_spells = []

# Define the spells that can be casted
func add_spell_id_to_list(spell_id: String) -> void:
	var spell_data = spell_loader.get_spell_by_id(spell_id)
	var cd = spell_data["cooldown"]
	castable_spells.append(SpellData.new(spell_id, cd))

func remove_spell_id_from_list(spell_id: String) -> void:
	for i in range(castable_spells.size()):
		if castable_spells[i].id == spell_id:
			castable_spells.remove(i)
			break

# Function to update the spell cooldowns
func _process(delta: float) -> void:
	for casted_spell in castable_spells:
		var spellState = casted_spell.state
		var spell2 = SpellState.COOLDOWN
		if casted_spell.state == SpellState.COOLDOWN:
			casted_spell.remaining_cooldown = max(0, casted_spell.remaining_cooldown - delta)
			if casted_spell.remaining_cooldown <= 0:
				casted_spell.state = SpellState.READY

# Function to cast a spell
func cast_spell(spell_id: String):
	var casted_spell = find_casted_spell_by_id(spell_id)
	if casted_spell and casted_spell.state == SpellState.READY:
		casted_spell.state = SpellState.CASTING
		casted_spell.remaining_cooldown = casted_spell.cooldown
		# TODO: Add casting logic here...
		# Make sure we always set the SpellState to COOLDOWN at the very end so that the timer can start.
		casted_spell.state = SpellState.COOLDOWN
		
		# Grab the spell data to attach. This is just the base data, it doesn't include player stats yet
		var spell_data = spell_loader.get_spell_by_id(spell_id)
		return spell_data
	return null

# Function to find spell data by ID
func find_casted_spell_by_id(spell_id: String) -> SpellData:
	for spell_data in castable_spells:
		if spell_data.id == spell_id:
			return spell_data
	return null
