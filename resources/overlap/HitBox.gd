extends Area2D

# Example spell
#{
	#"id": "fireball",
	#"name": "Fireball",
	#"description": "A single fireball",
	#"type": "Fire",
	#"maxDistance": 99999,
	#"cooldown": 1,
	#"castTime": 0,
	#"projectileSpeed": 100,
	#"damage": 10
#}

@export var damage_dealt: int = 0
@export var damage_type: String = "Normal"
@export var projectile_speed: int = 100
# TODO: Add "break on x hits"
# TODO: Add "break after x distance"

func set_projectile_data(_damage_dealt: int, _damage_type: String, _projectile_speed: int):
	damage_dealt = _damage_dealt
	damage_type = _damage_type
	projectile_speed = _projectile_speed

func destroy():
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy()

func register_hit(thing):
	print("hit: ", thing)
	destroy()

func _on_area_entered(area):
	register_hit(area)

func _on_body_entered(body):
	register_hit(body)
