extends CharacterBody2D

@export var speed: int = 100
@onready var animations = $AnimationPlayer

@export var maxHealth: int = 3
@onready var currentHealth: int = maxHealth
@onready var effects = $Effects
@onready var hurtBox = $hurtBox
@onready var hurtTimer = $Effects/hurtTimer

@export var knockbackPower: int = 500

@export var inventory: Inventory

var isHurt: bool = false

signal healthChanged

func _ready():
	effects.play("RESET")

func handleInput():
	var moveDirection = Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	velocity = moveDirection*speed

func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
	else:
		var direction = "Down"
		if velocity.x < 0: direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		
		animations.play("walk" + direction)

func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider =collision.get_collider()
		

func _physics_process(delta):
	handleInput();
	move_and_slide()
	handleCollision()
	updateAnimation()
	if !isHurt:
		for area in hurtBox.get_overlapping_areas():
			if area.name == "hitBox":
				hurtByEnemy(area)

func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth <= 0:
		currentHealth = maxHealth
			
	healthChanged.emit(currentHealth)
	isHurt = true
	# call the knockback
	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	await hurtTimer.timeout
	effects.play("RESET")
	isHurt = false

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func _on_hurt_box_area_entered(area):
	if area.has_method("collect"):
		area.collect(inventory)
