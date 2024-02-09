extends Node2D

var enemy = preload("res://resources/entity/enemy/EnemyBase.tscn")

@onready var gameOverSound: AudioStreamPlayer2D = $GameOverSound

func _on_player_base_player_died():
	gameOverSound.play()


func _on_enemey_spawn_timer_timeout():
	var enemy_instance = enemy.instantiate()
	enemy_instance._set_player($TileMap/PlayerBase)
	add_child(enemy_instance)
	
	var nodes = get_tree().get_nodes_in_group("spawn")
	var node = nodes[randi() % nodes.size()]
	var position = node.position
	enemy_instance.position = position
