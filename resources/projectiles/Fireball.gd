extends "res://resources/overlap/HitBox.gd"

@export var SPEED: int = 100
@onready var animations = $AnimationPlayer


func _physics_process(delta):
	animations.play("move")
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

func destroy():
	queue_free()


func _on_Fireball_area_entered(area):
	destroy()


func _on_Fireball_body_entered(body):
	destroy()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
