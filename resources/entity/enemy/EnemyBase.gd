extends "res://resources/entity/EntityBase.gd"

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

var player: Node2D

func _set_player(_player):
	player = _player

func _physics_process(delta) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * SPEED
	move()
	
func makepath():
	nav_agent.target_position = player.global_position


func _on_timer_timeout():
	#Makes new path every timeout
	makepath()
