extends Node2D

@onready var gameOverSound: AudioStreamPlayer2D = $GameOverSound

func _on_player_base_player_died():
	gameOverSound.play()
