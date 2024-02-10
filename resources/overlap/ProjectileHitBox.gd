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

# All Projectiles should have an AnimationPlayer attached to them
@onready var animations = get_node("AnimationPlayer")
@export var damage_dealt: int = 0
@export var damage_type: String = "Normal"
@export var projectile_speed: int = 100
@export var projectile_id: String = ""
@export var max_distance: int = 100
# TODO: Add "break on x hits"
# TODO: Add "break after x distance"

func set_projectile_data(castedSpell):
	damage_dealt = castedSpell.damage
	damage_type = castedSpell.type
	projectile_speed = castedSpell.projectileSpeed
	projectile_id = castedSpell.id
	max_distance = castedSpell.maxDistance

func destroy():
	queue_free()
	
func _on_projectile_hit_enemy(projectile: Area2D, target: Node2D):
	if projectile.projectile_id == "rockThrow":
		pass
	else:
		projectile.destroy()

func _ready():
	SignalBus.projectile_hit_target.connect(_on_projectile_hit_enemy)

func _physics_process(delta):
	if animations:
		animations.play("shoot")
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += projectile_speed * direction * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	pass

func _on_body_entered(body):
	if body.is_in_group("Terrain"):
		destroy()
	pass # Replace with function body.
