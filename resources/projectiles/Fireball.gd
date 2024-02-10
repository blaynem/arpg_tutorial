extends "res://resources/overlap/HitBox.gd"

@export var SPEED: int = 100
@onready var animations = $AnimationPlayer


func _physics_process(delta):
	animations.play("move")
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta
