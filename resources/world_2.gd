extends Node2D

var enemy = preload("res://resources/entity/enemy/EnemyBase.tscn")

@onready var gameOverSound: AudioStreamPlayer2D = $GameOverSound

@export var maxMonstersAlive: int = 4
@onready var label: Label = $TileMap/PlayerBase/Camera2D/Label

var totalAliveMonsters = 0
var monstersSlain = 0


func _on_thing_dead():
	monstersSlain += 1
	totalAliveMonsters -= 1

	# String interpolation
	var killsFormatString = "Kills: %s"
	label.text = killsFormatString % monstersSlain

func _on_player_base_player_died():
	gameOverSound.play()

func _on_enemy_spawn_timer_timeout():
	var enemy_instance = enemy.instantiate()
	enemy_instance._set_player($TileMap/PlayerBase)
	enemy_instance._set_hp(5)
	add_child(enemy_instance)
	totalAliveMonsters += 1
	
	enemy_instance.connect("died", _on_thing_dead)
	
	var nodes = get_tree().get_nodes_in_group("spawn")
	var node = nodes[randi() % nodes.size()]
	var position = node.position
	enemy_instance.position = position

