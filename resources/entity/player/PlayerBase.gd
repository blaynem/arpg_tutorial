extends "res://resources/entity/EntityBase.gd"

signal player_died

@export var SHURIKEN: PackedScene = preload("res://resources/projectiles/PlayerBigShuriken.tscn")

@onready var attackTimer = $AttackTimer

func _physics_process(delta):
	handleInput();
	move()
	
func die():
	super.die()
	player_died.emit()

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	velocity = moveDirection * SPEED
	
	if Input.is_action_just_pressed("action_attack") and attackTimer.is_stopped():
		var shuriken_direction = self.global_position.direction_to(get_global_mouse_position())
		throw_shuriken(shuriken_direction)


func throw_shuriken(shuriken_direction: Vector2):
	if SHURIKEN:
		var shuriken = SHURIKEN.instantiate()
		get_tree().current_scene.add_child(shuriken)
		shuriken.global_position = self.global_position
		
		var shuriken_spin = shuriken_direction.angle()
		shuriken.rotation = shuriken_spin
		
		attackTimer.start()
