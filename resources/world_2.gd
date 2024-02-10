extends Node2D

var enemy = preload("res://resources/entity/enemy/EnemyBase.tscn")

@onready var gameOverSound: AudioStreamPlayer2D = $GameOverSound

@export var maxMonstersAlive: int = 4
@onready var label: Label = $TileMap/PlayerBase/Camera2D/Label

var totalAliveMonsters = 0
var monstersSlain = 0

var enemy_loader = EnemyLoader.get_instance()

func _on_thing_dead():
	monstersSlain += 1
	totalAliveMonsters -= 1

	# String interpolation
	var killsFormatString = "Kills: %s"
	label.text = killsFormatString % monstersSlain

func _on_player_base_player_died():
	gameOverSound.play()

func create_enemy(enemy_name):
	var enemy_data = enemy_loader.get_data_by_id(enemy_name)
	if not enemy_data:
		return
	# Example: Create enemy node and configure it using data
	var enemy_instance = enemy.instantiate()
	enemy_instance._set_enemy_data(enemy_data)
	enemy_instance._set_target($TileMap/PlayerBase)
	enemy_instance.connect("died", _on_thing_dead)
	
	add_child(enemy_instance)
	totalAliveMonsters += 1
	
	var nodes = get_tree().get_nodes_in_group("spawn")
	var node = nodes[randi() % nodes.size()]
	enemy_instance.position = node.position

const enemyNames = ["slime_1", "slime_2", "spit_slime_1"]
func _on_enemy_spawn_timer_timeout():
	create_enemy(enemyNames[randi() % enemyNames.size()])

