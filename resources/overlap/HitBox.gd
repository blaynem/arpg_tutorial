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

func register_enemy_hit(hitbox):
	var thing = hitbox
	var thing2 = thing.get_path() as String
	if "rockthrow" in thing2.to_lower():
		return
	# We know this is called directly from EnemyBase
	# So we know its not a tile, so dont break the projectile as it goes through all enemies.
	destroy()

# On enemy hit box..? but only sometimes?!
func _on_area_entered(area):
	pass
	# TODO: Determine what this actually is getting hit on
	#print("hit: ", area)
	## This can be from a few different things.
	#if area.is_in_group("Projectiles"):
		#pass
	#destroy()

# Walls, and Tilemap things, occasionally an enemy though..
# I think this has to do with the collisions thingy Monitoring / Monitorable. Figure that out.
# easiest to test by letting a ton of enemies stack up around you then cast
func _on_body_entered(body):
	destroy()
