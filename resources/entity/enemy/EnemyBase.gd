extends "res://resources/entity/EntityBase.gd"

# TODO: Move this later
const sprites = {
	"slime_1": "res://resources/sprites/actors/Slime2/Slime2.png",
	"slime_2": "res://resources/sprites/actors/Slime4/Slime4.png",
	"spit_slime_1": "res://resources/sprites/actors/Slime/Slime.png"
}

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

var target: Node2D

var enemyStats: = {}

func _set_target(_target):
	target = _target

func _physics_process(delta) -> void:
	var dir = to_local(nav_agent.get_next_path_position()).normalized()
	velocity = dir * SPEED
	move()
	
func makepath():
	nav_agent.target_position = target.global_position

func _set_enemy_data(data: Dictionary) -> void:
	_set_hp(data["health"])
	_set_hp_max(data["health"])
	SPEED = data["speed"]
	display_name = data["name"]
	
	var player: CharacterBody2D = $"."
	$Sprite2D.texture = load(sprites[data["id"]])
	player.scale.x = data["size"]
	player.scale.y = data["size"]
	enemyStats = data


func calculateDamage(hitbox: Area2D):
	if hitbox.is_in_group("Projectiles"):
		hitbox.register_enemy_hit(hitbox)
		# We also now have access to damage types here. So we can make a resistance system
		var damageDone = hitbox.damage_dealt
		var newHealth = hp - damageDone
		_set_hp(newHealth)
		spawn_effect(EFFECT_HIT)
		spawn_dmgIndicator(damageDone)


func _on_hurt_box_area_entered(hitbox):
	var didDamage = calculateDamage(hitbox)

func _on_timer_timeout():
	#Makes new path every timeout
	makepath()
